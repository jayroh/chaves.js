describe "Chaves", ->

  describe "by default", ->

    beforeEach ->
      loadFixtures('default-list.html')
      @list     = $('#list').chaves()
      @children = @list.children()
      @help     = $('.jquery-chaves-help')
      @search   = $('#search')

    afterEach ->
      key.deleteScope('all')
      $('.jquery-chaves-help').remove()
      $('#list li').
        attr('class', '').
        eq('0').
        addClass('active')

    it "adds 'jquery-chaves' to target element's className", ->
      expect(@list).toHaveClass('jquery-chaves')

    it "adds 'active' to first child element's className", ->
      expect(@children.eq(0)).toHaveClass('active')

    it "builds the help dialog", ->
      expect($('.jquery-chaves-help h3')).toHaveText('Keyboard Shortcuts')
      expect($('.jquery-chaves-help dl').text()).toContain('kMove selection up.')
      expect($('.jquery-chaves-help dl').text()).toContain('jMove selection down.')

    describe "when 'j' is pressed", ->

      describe "once", ->

        it "moves 'active' class from first to second child", ->
          key.triggerKey('j')
          expect(@children.eq(1)).toHaveClass('active')
          expect(@children.eq(0)).not.toHaveClass('active')

      describe "twice", ->

        it "moves 'active' to third child", ->
          key.triggerKey('j')
          key.triggerKey('j')
          expect(@children.eq(2)).toHaveClass('active')

      describe "too many times", ->

        it "keeps 'active' on the last child", ->
          key.triggerKey('j') for [1..10]
          expect(@children.last()).toHaveClass('active')

    describe "when 'k' is pressed", ->

      beforeEach ->
        key.triggerKey('j') for [1..6]
        return

      describe "once", ->

        it "moves 'active' class from last to second child", ->
          key.triggerKey('k')
          expect(@children.last().prev()).toHaveClass('active')
          expect(@children.last()).not.toHaveClass('active')

      describe "twice", ->

        it "moves 'active' to third child", ->
          key.triggerKey('k')
          key.triggerKey('k')
          expect(@children.last().prev().prev()).toHaveClass('active')

      describe "too many times", ->

        it "keeps 'active' on the first child", ->
          key.triggerKey('k') for [1..10]
          expect(@children.first()).toHaveClass('active')

    describe "after pressing '?'", ->

      it "toggles the help div", ->
        key.triggerKey('shift+/')
        expect(@help).toHaveClass('visible')
        key.triggerKey('shift+/')
        expect(@help).not.toHaveClass('visible')

      describe "and pressing 'esc'", ->

        it "hides the help div", ->
          key.triggerKey('shift+/')
          expect(@help).toHaveClass('visible')
          key.triggerKey('esc')
          expect(@help).not.toHaveClass('visible')

    describe "when pressing '/'", ->

      it "focuses on search", ->
        key.triggerKey('/')
        expect(@search).toBeFocused()
