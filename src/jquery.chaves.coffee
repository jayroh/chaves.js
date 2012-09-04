$.fn.extend
  chaves: (options) ->
    self = $.fn.chaves
    options = $.extend {}, self.default_options, options
    $(this).each (i, el) ->
      self.init el, options

$.extend $.fn.chaves,
  version:
    '0.1.1'
  default_options:
    activeClass: 'active'
    bindings: []
    childSelector: '> *'
    className: 'jquery-chaves'
    enableUpDown: false
    helpModalClass: 'jquery-chaves-help'
    linkSelector: 'a:first'
    scope: 'all'
    searchSelector: '.search,
                     #search,
                     input[type="text"][value*="earch"],
                     input[type="text"][placeholder*="earch"]'

  init: (el, options) ->
    @options  = options
    @bindings = $.extend [], options.bindings
    @el       = $(el).addClass(options.className)
    @children = @el.find(options.childSelector)
    @active   = @children.first().addClass(options.activeClass)
    @index    = 0
    @help     = @findOrCreateHelp()
    downkeys  = 'j'
    upkeys    = 'k'
    if options.enableUpDown
      downkeys  += ", down"
      upkeys    += ", up"

    # *************************************************************************

    register_all_bindings = =>
      for binding in @bindings
        key binding[0], @options.scope, binding[2]
        addToHelp binding[0], binding[1]

    addToHelp = (keys, description) =>
      @help.find('dl').append("<dt>#{keys}</dt><dd>#{description}</dd>")

    # *************************************************************************

    goUp = =>
      if(@index > 0)
        @index = @index - 1
        prev = $(@children[@index]).addClass(@options.activeClass)
        @active.removeClass(@options.activeClass)
        @active = prev
        @readjust(150)

    goDown = =>
      if(@index < @children.length - 1)
        @index = @index + 1
        next = $(@children[@index]).addClass(@options.activeClass)
        @active.removeClass(@options.activeClass)
        @active = next
        @readjust(0)

    showHelp = =>
      @help.toggleClass('visible')

    hideHelp = =>
      @help.removeClass('visible')

    searchFocus = =>
      @search = $(@options.searchSelector)
      window.setTimeout( (=> @search.focus()), 10 )

    clickActive = =>
      link = @active.find(@options.linkSelector)
      if link.trigger('click').attr('target') == '_blank'
        window.open link.attr('href'), 'popped'
      else
        window.location.href = link.attr('href')

    # *************************************************************************

    @bindings.push [ upkeys,        'Move selection up.',   goUp        ]
    @bindings.push [ downkeys,      'Move selection down.', goDown      ]
    @bindings.push [ 'shift+/',     'Toggle help dialog.',  showHelp    ]
    @bindings.push [ 'esc, escape', 'Close help dialog.',   hideHelp    ]
    @bindings.push [ '/',           'Focus on search.',     searchFocus ]
    @bindings.push [ 'enter',       'Open/click element.',  clickActive ]

    register_all_bindings()

  readjust: (buffer) ->
    if @elementOutOfViewport(@active[0])
      top = @active.offset().top - buffer
      $(window).scrollTop(top).trigger('scroll')

  elementOutOfViewport: (el) ->
    if el
      rect = el.getBoundingClientRect()
      !(rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= window.innerHeight &&
        rect.right <= window.innerWidth)

  findOrCreateHelp: () ->
    helpSelector = ".#{@options.helpModalClass}"
    unless $(helpSelector).length
      $('body').append("<div class=#{@options.helpModalClass}></div>")
      help = $(helpSelector).append('<h3>Keyboard Shortcuts</h3><dl></dl>')
    $(helpSelector)
