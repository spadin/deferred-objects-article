class window.Game
  constructor: (options = {}) ->
    @element  = options.element  or $("#mouse-dexterity-game")
    @template = options.template or JST['templates/game']
    @gameover = false

    @timer = new Timer()
    @timer.progress @timerUpdate

    @render()

  timerUpdate: (elapsedTime) =>
    @printMessage(elapsedTime/1000)

  render: ->
    @element.append @template()
    @messageElement = $(".message", @element) 

  startTimer: ->
    @timer.start()

  stopTimer: ->
    @timer.stop()

  renderBoard: ->
    $(".board", @element).empty()
    _.each @board.getPieces(), (piece) =>
      $(".board", @element).append piece.render()

  bindBoard: ->
    safePiecesMousedOver    = (piece.promise() for piece in @board.getSafePieces())
    nonSafePiecesMousedOver = (piece.promise() for piece in @board.getNonSafePieces())

    $.when(safePiecesMousedOver...).then =>
      @handleGameover true

    _.each safePiecesMousedOver, (piece) =>
      pieceMousedOver = piece.promise()
      $.when(pieceMousedOver).then (evt) =>
        target = evt.currentTarget
        $(target).css("opacity", "1")
        unless @running or @gameover
          $("img").hide()
          @running = true
        @startTimer()

    _.each nonSafePiecesMousedOver, (piece) =>
      pieceMousedOver = piece.promise()
      $.when(pieceMousedOver).then =>
        @handleGameover false
        @reset()

  setup: (@map) ->
    pieces = (new Piece({safe}) for safe in map)
    @board = new Board {pieces}
    @gameover = false
    @renderBoard()
    @bindBoard()

  printMessage: (message) ->
    @messageElement.text message

  reset: ->
    @running = false
    @setup @map
    @timer.reset()

  handleGameover: (@winner) ->
    @stopTimer()
    @gameover = true
    @printMessage if @winner then "You win! #{@timer.elapsedTime/1000}" else "You lose, try again."
    $("img").hide()
    $("img.win", @element).show() if @winner
    $("img.lose", @element).show() unless @winner

  isGameover: -> @gameover

