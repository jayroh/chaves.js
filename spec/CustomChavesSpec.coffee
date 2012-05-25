describe "Chaves", ->

  describe "when overriding options", ->

    beforeEach ->
      window.msgs = []
      window.alert = (msg) -> msgs.push msg
      loadFixtures('custom-list.html')
      @list = $('#messages').chaves
        className: 'keys'
        childSelector: '> div'
        activeClass: 'on'
        enableUpDown: true
        bindings: [
          ['n', 'Alert n!', -> alert('You pressed n!')],
          ['p', 'Alert p!', -> alert('You pressed p!')]
        ]
      @children = @list.children()
      @help = $('.help')
      @search = $('#search')

    afterEach ->
      key.deleteScope('all')
      $('.jquery-chaves-help').remove()
      $('#list li').
        attr('class', '').
        eq('0').
        addClass('active')

    it "adds 'keys' to target element's className", ->
      expect(@list).toHaveClass('keys')

    it "adds 'on' to first child div", ->
      expect(@list.find('> div')).toHaveClass('on')

    it "adds custom keys to help dialog", ->
      expect($('.jquery-chaves-help dl').text()).toContain('nAlert n!')
      expect($('.jquery-chaves-help dl').text()).toContain('pAlert p!')

    describe "when j, k, down and up are pressed a bunch", ->
      it "moves 'on' from first to third div and back", ->
        key.triggerKey('j')
        key.triggerKey('down')
        expect(@children.eq(2)).toHaveClass('on')
        expect(@children.eq(0)).not.toHaveClass('on')
        key.triggerKey('k')
        key.triggerKey('up')
        expect(@children.eq(1)).not.toHaveClass('on')
        expect(@children.eq(2)).not.toHaveClass('on')
        expect(@children.eq(0)).toHaveClass('on')

    describe "when n or p are pressed", ->
      it "triggers the custom bindings", ->
        key.triggerKey('n')
        expect(msgs).toContain('You pressed n!')
        key.triggerKey('p')
        expect(msgs).toContain('You pressed p!')
