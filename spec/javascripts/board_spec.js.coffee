describe 'Board', ->
  board = null
  beforeEach ->
    board = new Board

  it 'is initialized with no pieces', ->
    expect(board.getPieces().length).toBe 0

  it 'can be initialized with an array of pieces', ->
    pieces = []
    pieces.push new Piece
    pieces.push new Piece

    board = new Board
      pieces: pieces

    expect(board.getPieces().length).toBe 2

  it 'allows pieces to be added', ->
    piece = new Piece
    board.addPiece piece
    expect(board.getPieces().length).toBe 1

  describe 'getting different types of pieces', ->
    safePiece1   = null
    safePiece2   = null
    nonSafePiece = null

    beforeEach ->
      safePiece1   = makeSafePiece()
      safePiece2   = makeSafePiece()
      nonSafePiece = makeNonSafePiece()

      board.addPiece safePiece1
      board.addPiece safePiece2
      board.addPiece nonSafePiece

    it 'returns all the safe pieces', ->
      safePieces = board.getSafePieces()

      expect(safePieces[0]).toBe safePiece1
      expect(safePieces[1]).toBe safePiece2

    it 'returns all the non-safe pieces', ->
      nonSafePieces = board.getNonSafePieces()
      expect(nonSafePieces[0]).toBe nonSafePiece

    makeNonSafePiece = ->
      new Piece
        safe: false

    makeSafePiece = ->
      new Piece
        safe: true
