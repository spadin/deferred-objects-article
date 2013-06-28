describe 'Game', ->
  game = null

  [SAFE, NON_SAFE] = [true, false]
  S = SAFE
  N = NON_SAFE

  gameMap = [
    S, N, N, N, N, S, S, S, S, S,
    S, N, S, S, S, S, N, N, N, S,
    S, N, S, N, S, S, N, S, S, S,
    S, N, S, N, S, S, N, S, N, N,
    S, S, S, N, N, N, N, S, S, S,
  ]

  element = null

  beforeEach ->
    element = $("<div></div>")
    game = new Game {element}

  describe 'game setup', ->
    beforeEach ->
      game.setup gameMap

    it 'can setup the board', ->
      expect(game.board.getPieces().length).toBe 5*10
      for piece, i in game.board.getPieces()
        expect(piece.isSafe()).toBe gameMap[i]

    it 'can reset the board', ->
      oldPieces = game.board.getPieces()
      game.reset()
      for piece, i in game.board.getPieces()
        expect(piece).not.toBe oldPieces[i]

  describe 'templating', ->
    it 'allows a base element to be set', ->
      element = $("<div></div>")
      game = new Game {element}
      expect(game.element).toBe element

    it 'allows a template to be set', ->
      template = -> "hello world"
      game = new Game {template}
      expect(game.template()).toEqual "hello world"

  describe 'rendering', ->
    it 'renders the pieces into element', ->
      game.setup gameMap
      expect($(".piece", game.element).length).toBe gameMap.length

  describe 'hud', ->
    it 'prints a message', ->
      game.setup gameMap
      game.printMessage "some message here"
      expect($(".message", game.element).text()).toBe "some message here"

  describe 'gameplay', ->
    beforeEach ->
      game.setup gameMap

    it 'knows the game is not over', ->
      expect(game.isGameover()).toBeFalsy()

    it 'knows the game is over when all safe pieces are moused over', ->
      _.each game.board.getSafePieces(), (piece) ->
        $(piece.render()).mouseover()
      expect(game.isGameover()).toBeTruthy()

    xit 'knows the game is over when non-safe piece is moused over', ->
      nonSafePieces = game.board.getNonSafePieces()
      $(nonSafePieces[0].render()).mouseover()
      expect(game.isGameover()).toBeTruthy()

    it 'display a message when player wins', ->
      game.handleGameover true
      expect($(".message", game.element).text()).toContain "You win!"

    it 'display a message when player loses', ->
      game.handleGameover false
      expect($(".message", game.element).text()).toBe "You lose, try again."
