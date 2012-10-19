# Asset route definitions

class App < Sinatra::Base

  # Asset manager
  get "/app/*/*.*" do |type, path, ext|
    expires Time.now, :public, :must_revalidate
    path = request.path_info
    path.chomp!(File.extname(path))

    # javascript/coffeesscript
    if type == "scripts" and ext == "js"
      # set content type
      content_type :js

      file = {
        :coffee => root_path("#{path}.coffee"),
        :js     => root_path("#{path}.js")
      }

      # look for coffeescript files
      if File.exists?(file[:coffee])
        coffee File.read(file[:coffee])

      # next look for plain old js files
      elsif File.exists?(file[:js])
        send_file file[:js]

      # not found
      else
        404

      end

    # scss stylesheets
    elsif type == "styles" and ext == "css"
      # set content type
      content_type :css

      file = {
        :scss => root_path("#{path}.scss"),
        :css  => root_path("#{path}.css")
      }

      # we support scss only
      # look for scss files
      if File.exists?(file[:scss])
        scss File.read(file[:scss])

      # next look plain old css files
      elsif File.exists?(file[:css])
        send_file file[:css]

      # not found
      else
        404

      end

    # js templates
    elsif type == "templates" and ext == "html"
      # set content type
      content_type :html

      file = {
        :html => root_path("#{path}.html")
      }

      # send file as-is
      if File.exists?(file[:html])
        send_file file[:html]

      # not found
      else
        404

      end

    # not found
    else
      404

    end
  end

end
