class window.Piece
  constructor: (options = {}) ->
    @safe     = options.safe or false
    @template = options.template or JST['templates/piece']

  isSafe: ->
    @safe

  render: ->
    unless @dom
      @dom = @makeDomNode @template {piece: @}
      @deferred = $.Deferred()
      @bind()
    @dom

  makeDomNode: (html) ->
    $(html).get(0)

  handleMouseover: ->
    @deferred.resolve arguments...

  bind: ->
    $(@dom).on 'mouseover', => @handleMouseover arguments...

  promise: ->
    @deferred.promise()
