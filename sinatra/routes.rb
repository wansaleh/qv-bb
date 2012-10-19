# Sinatra route definitions

class App < Sinatra::Base

  get "/" do
    haml :index
  end

  get "/sura/:sura_id" do
    sura_id = params[:sura_id].to_i

    if valid?(sura_id)
      haml :index
    else
      @error = "You've put in an invalid Sura ID. Quran has 114 suras. Be sure to request a sura_id between 1 and 114."
      500
    end
  end

  LIMIT = 20
  get "/api/ayas" do
    sura_id = params[:sura_id].to_i
    limit   = !params[:limit].blank? ? params[:limit].to_i   : LIMIT
    offset  = !params[:offset].blank? ? params[:offset].to_i : 0

    limit   = [limit, 0].max
    offset  = [offset, 0].max

    if !valid?(sura_id)
      hash = {:error => "Invalid sura"}
    else
      hash = ayas(sura_id, limit, offset)
    end

    json = hash.to_json
    json = "#{params[:callback]}(#{json})" unless params[:callback].blank?

    content_type :json, :charset => "utf-8"
    json
  end

  get "/api/suras" do
    sura_id = !params[:sura_id].blank? ? params[:sura_id].to_i : false

    if sura_id
      if !valid?(sura_id)
        hash = {:error => "Invalid sura"}
      else
        hash = suras(sura_id)
      end
    else
      hash = suras
    end

    json = hash.to_json
    json = "#{params[:callback]}(#{json})" unless params[:callback].blank?

    content_type :json, :charset => "utf-8"
    json
  end

  def ayas(sura_id, limit = 10, offset = 0)
    DB[:ayas]
      .select(:ayas__id, :ayas__sura_id, :ayas__aya, :ayas__text___text, :translations__text___translation)
      .join(:translations, :ayas__id => :translations__aya_id)
      .where(:ayas__sura_id => sura_id, :translations__language_id => 1)
      .limit(limit, offset)
      .all
  end

  def suras(sura_id = :all)
    if sura_id == :all
      DB[:suras].all
    else
      DB[:suras].where(:id => sura_id).first
    end
  end

  # def translations(sura_id, language_id = 1, limit = 10, offset = 0)
  #   DB[:ayas]
  #     .select(:translations__text___translation)
  #     .join(:translations, :ayas__id => :translations__aya_id)
  #     .where(:ayas__sura_id => sura_id, :translations__language_id => 1)
  #     .limit(limit, offset)
  #     .all
  # end

  def valid?(sura_id)
    sura_id.to_i.between?(1, 114)
  end

end
