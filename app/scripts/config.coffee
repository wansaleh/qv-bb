# Set the require.js configuration for your application.
prefix = {}
prefix.js      = "/assets/js"
prefix.libs    = "#{prefix.js}/libs"
prefix.plugins = "#{prefix.js}/plugins"

require.config
  urlArgs: "cb=" + (new Date()).getTime()

  # Initialize the application with the main application file.
  deps: ["main"]

  baseUrl: "/app/scripts"

  paths:
    # JavaScript folders.
    libs:    "/assets/js/libs"
    plugins: "/assets/js/plugins"
    vendor:  "/assets/vendor"

    # Libraries.
    jquery:     "#{prefix.libs}/jquery"
    underscore: "#{prefix.libs}/underscore"
    backbone:   "#{prefix.libs}/backbone"
    knockout:   "#{prefix.libs}/knockout"
    knockback:  "#{prefix.libs}/knockback-core"
    handlebars: "#{prefix.libs}/handlebars"

    # Underscore mixins.
    "underscore.string": "#{prefix.plugins}/underscore.string"

    # Backbone plugins.
    "backbone.layoutmanager": "#{prefix.plugins}/backbone.layoutmanager.0.7.0"
    "backbone.mutators":      "#{prefix.plugins}/backbone.mutators"
    "backbone.spark":         "#{prefix.plugins}/backbone.spark"
    # "backbone.modelbinder":   "#{prefix.plugins}/backbone.modelbinder"

    # Knockout plugins.
    "knockout.repeat": "#{prefix.plugins}/knockout.repeat"

    # Handlebars plugins.
    "handlebars.helpers": "#{prefix.plugins}/handlebars.helpers"

    # Quran vendor data.
    qurandata: "/assets/js/qurandata"

  shim:
    underscore:
      exports: "_"

    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"

    "backbone.layoutmanager": ["backbone"]
    "backbone.mutators": ["backbone"]
    "backbone.spark": ["backbone"]
    # "backbone.modelbinder": ["backbone"]

    qurandata:
      exports: "QuranData"
