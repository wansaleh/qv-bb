define [
  # Libraries.
  "jquery"
  "underscore"
  "backbone"

  # underscore.string
  "underscore.string"
],

($, _, Backbone, _s) ->

  # Arabic numbers, 1-9
  arabicNums = ["\u0660", "\u0661", "\u0662", "\u0663", "\u0664", "\u0665", "\u0666", "\u0667", "\u0668", "\u0669"]

  # mixin underscore.string
  _.mixin _s.exports()

  # Extend underscore.
  _.mixin
    # force obj to integer
    to_i: (obj, base) ->
      if _.isString obj
        number = obj.match /\d+/g
        parseInt (if number? then number.join('') else null), base
      else if _.isNumber obj
        parseInt obj, base

    # force obj to string
    to_s: (obj) ->
      (new String obj).toString()

    # ruby's %w :P
    w: (string) ->
      _.trim(string).replace(/\s+/g, ' ').split(' ')

    # ruby's Array.sample :P
    sample: (array) ->
      if _.isArray array then _.first(_.shuffle(array)) else array

    # translate number to arabic.
    arab: (number) ->
      _.to_s(number).replace /[0-9]/g, (w) -> arabicNums[+w]

    # Append suffixes to numbers.
    ordinal: (number) ->
      number = _.to_i number
      n = number % 100;
      suffix = _.w 'th st nd rd th'
      ord = if n < 21 then (if n < 4 then suffix[n] else suffix[0]) else (if n % 10 > 4 then suffix[0] else suffix[n % 10])
      number + ord

  # patch _.each, to include _.w
  _.each = do ->
    each = _.each
    ->
      args = Array::slice.call(arguments)
      obj = args.shift()
      obj = _.w obj if _.isString obj
      each.apply _, [obj].concat(args)

  # jQuery small plugins
  $.fn.scrollTo = (options = {}) ->
    options = _.defaults options, { duration: 1000, callback: $.noop, offset: 0 }
    $('body').animate
      scrollTop: $(@).offset().top + options.offset,
      options.duration,
      options.callback.bind @
    @

  # Shortcut for console.log
  window.log = ->
    console.log.apply(console, arguments)

  do ->
    # Expose underscore methods to native array
    # _ methods that we want to implement on Array.
    methods = ['each', 'map', 'reduce', 'reduceRight', 'detect', 'select',
      'reject', 'all', 'any', 'include', 'invoke', 'pluck', 'max', 'min', 'sortBy',
      'sortedIndex', 'toArray', 'size', 'first', 'rest', 'last', 'without',
      'indexOf', 'lastIndexOf', 'isEmpty']

    # Mix in each method as a proxy.
    _.each methods, (method) ->
      Array::[method] = ->
        _[method].apply(_, [this].concat(_.toArray(arguments)))

  # Utility helper functions
  factory = (app) ->
    expose: (name, object) ->
      window[name] = object if app.debug

  # Return for AMD
  factory
