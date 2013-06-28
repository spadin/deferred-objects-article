describe 'Piece', ->
  piece = null

  beforeEach ->
    piece = new Piece
      template: (data) ->
        "<p>piece is safe: #{data.piece.safe}</p>"

  describe 'initialization', ->
    it 'defaults to being a non-safe piece', ->
      piece = new Piece
      expect(piece.isSafe()).toBeFalsy()

    it 'can be made a safe piece during initialization', ->
      piece = new Piece
        safe: true
      expect(piece.isSafe()).toBeTruthy()

    it 'can be explicitly made non-safe during initialization', ->
      piece = new Piece
        safe: false
      expect(piece.isSafe()).toBeFalsy()

  describe 'templating', ->
    it 'accepts a template function', ->
      expect(piece.template({piece: {safe: false}})).toContain "piece is safe: false"

    it 'renders the template', ->
      node = piece.render()
      expect(node.innerHTML).toContain "piece is safe: false"

    it 'memoizes the dom node once rendered', ->
      node = piece.render()
      expect(piece.render()).toEqual node

    it 'sets "templates/piece" by default', ->
      piece = new Piece
        safe: true
      dom = piece.render()
      expect($(dom).hasClass("safe")).toBeTruthy()

  describe 'mouse interaction', ->
    beforeEach ->
      piece.render()
      piece.bind()

    it 'adds event listener for mouseover', ->
      spyOn piece, 'handleMouseover'
      $(piece.dom).mouseover()
      expect(piece.handleMouseover).toHaveBeenCalled()

    it 'fires a promise', ->
      cb = jasmine.createSpy()
      promise = piece.promise()
      promise.done  -> cb()
      $(piece.dom).mouseover()
      expect(cb).toHaveBeenCalled()
