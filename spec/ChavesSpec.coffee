describe "Chaves", ->

  describe "By Default", ->

    beforeEach ->
      loadFixtures('default-list.html')
      @list = $('ul').chaves()

    it "adds jquery-chaves to target element's className", ->
      expect(@list).toHaveClass('jquery-chaves')

    it "contains spec with an exception", ->
      expect(true).toBe(true)
