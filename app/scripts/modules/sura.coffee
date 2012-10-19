define [
  # Application.
  "app"

  # Libraries.
  "backbone"
],

(app, Backbone) ->

  # Create a new module
  Sura = app.createModule
    # Set some helpers

    # Check validity of sura id
    valid: (id) ->
      1 <= id <= 114

    # get Sura.Model by id
    byId: (id) ->
      return false unless Sura.valid id
      app.Data.Suras.get id

    # generate permalink of the sura
    permalink: (id) ->
      return false unless Sura.valid id
      if app.pushState then "/sura/#{id}" else "/#sura/#{id}"

  # ========================================================
  # Model
  class Sura.Model extends Backbone.Model
    defaults:
      id    : null
      name  : null
      tname : null
      ename : null
      ayas  : null
      order : null
      rukus : null
      type  : null

    mutators:
      permalink: -> Sura.permalink(@id)
      nextlink:  -> Sura.permalink(@id + 1)
      prevlink:  -> Sura.permalink(@id - 1)
      alfatihah: -> @id == 1

  # ========================================================
  # Collection
  class Sura.Collection extends Backbone.Collection
    model: Sura.Model
    url: "/api/suras"
    comparator: (sura) -> sura.get "id"

  # ========================================================
  # Views
  # Links of suras
  class Sura.Views.List extends Backbone.View
    template: "sura/list"
    className: "index-wrapper"

    initialize: ->
      @collection = @options.collection
      @collection.on "reset", @render, @
      @collection.on "reset", @observe, @

    data: ->
      suras: @collection.toJSON()

    beforeRender: ->
      @collection.each ((sura) ->
        @insertView ".suras", new Sura.Views.Item(model: sura)
      ), @

  # Sub View: Single sura link
  class Sura.Views.Item extends Backbone.View
    template: "sura/item"
    tagName: "a"
    className: "btn btn-primary btn-round"

    attributes: ->
      "href": @model.get "permalink"
      "data-sura": @model.get "id"

    data: ->
      @model.toJSON()

  Sura

  # UNUSED: ko viewmodels
  # # ========================================================
  # # ViewModel
  # Sura.ViewModel = (model, with_adjacents = false) ->
  #   _.each "id name tname ename ayas order rukus type", (attr) =>
  #     @[attr] = kb.observable model, attr

  #   # computed props
  #   @fullname    = ko.computed => "#{@id()} #{@tname()} #{@name()}"
  #   @fullnamealt = ko.computed => "<b>#{@id()}</b> #{@tname()} #{@name()}"
  #   @orderord    = ko.computed => _.ordinal @order()
  #   @location    = ko.computed => if @type() == "Meccan" then "Mecca" else "Medina"
  #   @permalink   = ko.computed => Sura.permalink @id()
  #   @idprev      = ko.computed => if Sura.valid(@id() - 1) then @id() - 1 else false
  #   @idnext      = ko.computed => if Sura.valid(@id() + 1) then @id() + 1 else false

  #   if with_adjacents
  #     @prev = ko.computed => if @idprev() then new Sura.ViewModel Sura.byId @idprev() else false
  #     @next = ko.computed => if @idnext() then new Sura.ViewModel Sura.byId @idnext() else false
  #   @