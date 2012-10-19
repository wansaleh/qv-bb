define [
  # Application.
  "app"

  # Libraries.
  "backbone"
  "knockout"
  "knockback"
],

(app, Backbone, ko, kb) ->

  Console = app.createModule()

  # console view
  class Console.View extends Backbone.View
    manage: false # dont manage layout

    el: "#console"

    events:
      "click #show": "showMessage"
      "click #reset": "hideMessage"

    # initialize: ->
    #   @model = new Backbone.Model
    #     messageVisible: false
    #     transport: "car"

    #   ko.applyBindings kb.viewModel(@model), @el

    # showMessage: ->
    #   @model.set messageVisible: true

    # hideMessage: ->
    #   @model.set messageVisible: false

  Console
