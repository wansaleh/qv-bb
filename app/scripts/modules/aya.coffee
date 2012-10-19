define [
  # Application.
  "app"

  # Libraries.
  "backbone"
],

(app, Backbone) ->

  # Create a new module
  Aya = app.createModule()

  # ========================================================
  # Model
  class Aya.Model extends Backbone.Model
    defaults:
      id          : null
      sura_id     : null
      aya         : null
      text        : null
      translation : null

    mutators:
      textalt:  -> if @sura_id != 1 && @aya == 1 then @text.slice(39) else @text
      image:    -> "/assets/images/ayas/#{@sura_id}_#{@aya}.png"
      aya_arab: -> _.arab @aya

  # ========================================================
  # Collection
  class Aya.Collection extends Backbone.Collection
    model: Aya.Model
    url: "/api/ayas"
    comparator: (aya) -> aya.get "aya"

  # ========================================================
  # Views
  # Main View: List of ayas
  class Aya.Views.List extends Backbone.View
    template: "aya/list"
    className: "ayas-wrapper"

    attributes: ->
      "data-sura": @options.info.get "id"

    initialize: ->
      @info       = @options.info
      @collection = @options.collection

      @collection.on "reset",  @render, @
      @collection.on "change", @render, @

    data: ->
      @info.toJSON()

    beforeRender: ->
      @collection.each ((aya) ->
        @insertView ".ayas", new Aya.Views.Item(model: aya)
      ), @

  # Sub View: Single aya
  class Aya.Views.Item extends Backbone.View
    template: "aya/item"
    tagName: "div"
    className: "aya-wrapper"

    attributes: ->
      "data-aya": @model.get "aya"

    data: ->
      @model.toJSON()

  Aya
