class window.Timer
  constructor: ->
    @reset()

  tick: =>
    currentTime = +(new Date())
    @elapsedTime = currentTime - @startTime
    @deferred.notify(@elapsedTime)

  start: ->
    unless @timer
      @elapsedTime = 0
      @startTime = +(new Date())
      @timer = setInterval(@tick, 10)

  stop: ->
    @deferred.resolve()
    clearTimeout(@timer)
    @timer = null

  reset: ->
    @deferred = jQuery.Deferred()
    @deferred.progress(@cb)

  progress: (@cb) ->
    @deferred.progress(@cb)
