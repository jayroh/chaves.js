$.fn.extend
  chaves: (options) ->
    self = $.fn.chaves
    options = $.extend {}, self.default_options, options
    $(this).each (i, el) ->
      self.init el, options
      self.log el if options.log

$.extend $.fn.chaves,
  default_options:
    className: 'jquery-chaves'
    enableUpDown: false
    log: true

  init: (el, options) ->
    el.className = options.className

  log: (msg) ->
    console?.log msg
