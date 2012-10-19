define [
  # Utilities.
  "utils"

  # Libraries.
  "jquery"
  "underscore"
  "backbone"
  "handlebars"

  # Plugins.
  "backbone.layoutmanager"
  "backbone.mutators"
  "backbone.spark"
],

(utils, $, _, Backbone, Handlebars) ->

  # Provide a global location to place configuration settings and module
  # creation.
  app =
    # The root path to run the application.
    root: "/"
    # use pushState?
    pushState: true
    # use Handlebars?
    handlebars: false
    # debugging?
    debug: true

  # Call the utils factory, passing the app namespace.
  utils = utils app

  # Localize or create a new JavaScript Template object.
  JST = window.JST = window.JST || {}

  # Configure LayoutManager with Backbone Boilerplate defaults.
  Backbone.LayoutManager.configure
    # Allow LayoutManager to augment Backbone.View.prototype.
    manage: true

    prefix: "app/templates/"

    fetch: (path) ->
      # Initialize done for use in async-mode
      done

      # Concatenate the file extension.
      path = path + ".html"

      # Set the template compiler.
      compiler = if app.handlebars then Handlebars.compile else _.template

      # If the template has not been loaded yet, then load.
      if !JST[path]
        done = @async();
        return $.ajax( url: app.root + path ).then (contents) ->
          JST[path] = compiler contents
          JST[path].__compiled__ = true

          done JST[path]

      # If the template hasn't been compiled yet, then compile.
      if app.handlebars and !JST[path].__compiled__
        JST[path] = Handlebars.template JST[path]
        JST[path].__compiled__ = true

      return JST[path]

  # Patch Model and Collection.
  _.each ["Model", "Collection"], (name) ->
    # Cache Backbone constructor.
    ctor = Backbone[name]
    # Cache original fetch.
    fetch = ctor.prototype.fetch

    # Override the fetch method to emit a fetch event.
    ctor.prototype.fetch = ->
      # Trigger the fetch event on the instance.
      @trigger "fetch", @

      # Pass through to original fetch.
      fetch.apply @, arguments

  # For Backbone.Spark, alias Function.prototype.dependsOn
  # name it deps, shorter
  Function::deps = ->
    Function.prototype.dependsOn.apply @, arguments

  # Mix Backbone.Events, modules, and layout management into the app object.
  _.extend app, {
    # Create a custom object with a nested Views object.
    createModule: (additionalProps) ->
      _.extend { Views: {} }, additionalProps

    # Helper for using layouts.
    useLayout: (el, options) ->
      # Create a new Layout with options.
      layout = new Backbone.Layout _.extend { el: el }, options

      # Cache the refererence.
      return @layout = layout
  }, Backbone.Events

  # Expose for debugging
  utils.expose "app", app

  # Return for AMD
  app
