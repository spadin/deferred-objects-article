class window.Board
  constructor: (options = {}) ->
    @pieces = options.pieces or []

  addPiece: (piece) ->
    @pieces.push(piece)

  getPieces: ->
    @pieces

  getSafePieces: ->
    @safePieces or= _.select @pieces, (piece) -> piece.isSafe() == true

  getNonSafePieces: ->
    @nonSafePieces or= _.select @pieces, (piece) -> piece.isSafe() == false
