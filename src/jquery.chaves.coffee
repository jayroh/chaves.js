$.fn.extend
  chaves: (options) ->
    self = $.fn.chaves
    options = $.extend {}, self.default_options, options
    $(this).each (i, el) ->
      self.init el, options

$.extend $.fn.chaves,
  version:
    '0.1.0'
  default_options:
    activeClass: 'active'
    bindings: []
    childSelector: '> *'
    className: 'jquery-chaves'
    enableUpDown: false
    helpModalClass: 'jquery-chaves-help'
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
      if(@active.prev().length)
        prev = @active.prev().addClass(@options.activeClass)
        @active.removeClass(@options.activeClass)
        @active = prev

    goDown = =>
      if(@active.next().length)
        next = @active.next().addClass(@options.activeClass)
        @active.removeClass(@options.activeClass)
        @active = next

    showHelp = =>
      @help.toggleClass('visible')

    hideHelp = =>
      @help.removeClass('visible')

    searchFocus = =>
      @search = $(@options.searchSelector).focus()

    # *************************************************************************

    @bindings.push [ upkeys,        'Move selection up.',   goUp        ]
    @bindings.push [ downkeys,      'Move selection down.', goDown      ]
    @bindings.push [ 'shift+/',     'Toggle help dialog.',  showHelp    ]
    @bindings.push [ 'esc, escape', 'Close help dialog.',   hideHelp    ]
    @bindings.push [ '/',           'Focus on search.',     searchFocus ]

    register_all_bindings()

  findOrCreateHelp: () ->
    helpSelector = ".#{@options.helpModalClass}"
    unless $(helpSelector).length
      $('body').append("<div class=#{@options.helpModalClass}></div>")
      help = $(helpSelector).append('<h3>Keyboard Shortcuts</h3><dl></dl>')
    $(helpSelector)
