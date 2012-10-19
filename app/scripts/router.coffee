define [
  # Application.
  "app"

  # Libraries.
  "underscore"
  "backbone"
  # "knockout"
  # "knockback"

  # Modules
  "modules/sura"
  "modules/aya"
  "modules/console"

  # Data
  "data"
],

# (app, _, Backbone, ko, kb, Sura, Aya, Console) ->
(app, _, Backbone, Sura, Aya, Console) ->

  # Defining the application router, you can attach sub routers here.
  class Router extends Backbone.Router
    routes:
      "": "index"
      "sura/:sura_id": "sura"

    # Methods.
    initialize: ->
      # The body element.
      @$body = $("body")

      # List all routes.
      @methods = _.map @routes, (name, route) -> name

      # sura_id local copy.
      @sura_id = null

      # Collections.
      @suras = app.Data.Suras
      @ayas = new Aya.Collection

      # Create a layout and associate it with the #main div.
      @layout = app.useLayout("#main")

      # # Setup console
      # @console = new Console.View
      # @console.$el.show()

    reset: ->
      do @ayas.reset

    setClass: (method) ->
      _.each @methods, (mtd) => @$body.removeClass mtd
      @$body.addClass method

    index: ->
      @$body.scrollTo(duration: 0)

      # No sura_id because we are in index view.
      @sura_id = null

      # Set body's class.
      @setClass "index"

      options = @options
        # Set suras
        collection: @suras

      # Insert the view into the layout.
      @layout.setView new Sura.Views.List(options)

      # Render the layout into the DOM.
      @layout.render()

    sura: (sura_id) ->
      @$body.scrollTo(duration: 0)

      # Set sura_id.
      @sura_id = _.to_i(sura_id)

      # Set body's class.
      @setClass "sura"

      # Reset.
      @reset()

      options = @options
        # Get the sura info.
        info: @suras.get(@sura_id)

        # Set up the ayas.
        collection: @ayas

      # Insert the view into the layout.
      @layout.setView new Aya.Views.List(options)

      # Render the layout into the DOM.
      @layout.render()

      # Fetch!
      @ayas.fetch data:
        sura_id: @sura_id
        # limit: options.info.get('ayas')

    options: (options) ->
      _.extend {
        # Set parent el
        parent: @layout.el
        $parent: @layout.$el
      }, options

  Router
