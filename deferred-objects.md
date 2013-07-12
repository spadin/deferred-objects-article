## Deferred Objects

A Deferred object is a mechanism for referencing a value which may (or may not) 
be available at a later point.

Every so often you may find yourself in a scenario where you require a certain 
number of operations to happen before you continue. These operations may need to 
happen in sequence or in any order, but they must all finish before the code can 
proceed.

### Using deferred objects for Ajax calls

A popular example is making multiple concurrent ajax calls and then using the 
returned data after all requests have completed.

    ajax1 = $.get("/file1.json")
    ajax2 = $.get("/file2.json")

    $.when(ajax1, ajax2).then (response1, response2) ->
      # ready to continue with data from both sources

<small>_The code examples in this article are written in CoffeeScript which 
compiles down to JavaScript._</small>

The intent of this code reads clearly. When the two ajax calls have finished 
loading, execute the anonymous function. The `$.when` and `deferred.then` 
functions are part of the [jQuery Deferred API][1]. Also of note, `$.get` returns a 
[jqXHR object][8], which extends the promise protocol, and is the reason it can be 
used as a parameter in the `$.when` function.

In the example above, the two ajax calls can occur independent of one another, 
however, sometimes you may need the response from the first ajax call before you 
can continue with the second operation. Normally, you may create a callback 
chain like the one below.

    $.get
      url: "/json/source-1"
      success: (response1) ->
        $.get
          url: "/json/source-2"
          data: { someVar: response1.someVal }
          success: (response2) ->
            $.get
              url: "/json/source-3"
              data: { someVar: response2.someVal }
              success: (response3) ->
                // finally do something here

A more elegant solution is to use a when/then chain which makes the code show less 
clutter.

    ajax1 = $.get
      url: "/json/source-1"

    ajax2 = (response1) ->
      $.get
        url: "/json/source-2"
        data: { someVar: response1.someVal }

    ajax3 = (response2) ->
      $.get
        url: "/json/source-3"
        data: { someVar: response2.someVal }

    chain = $.when(ajax1).then(ajax2).then(ajax3)
    chain.done (response3) ->
      # finally do something here

In the example above `ajax1` is a jqXHR object whereas `ajax2` and `ajax3` are 
functions that return a jqXHR object. The distinction is very important. The 
`deferred.then` function expects a callback which can return a promise. If any 
of the ajax requests fail, the `chain.done` callback will never be triggered, 
just as you would expect.

### Usefulness aside from Ajax requests

Ajax requests make for the best examples of futures because they're so commonly 
used. Some other cases where futures could be used include: File access, Web 
Workers or other asynchronous calls.

An interesting use of promises I've toyed around with is user interaction. I've 
embedded an example below that shows how you can combine deferred objects with 
mouse events to create a simple mouse dexterity game.

#### Code examples

<iframe src="http://localhost:9999/" frameborder="0" width="600" height="160" 
style="margin: 0 auto;"></iframe><br>
<small>[Play the game][7] in a new window or [view the source][2] on 
Github.</small>

In the game above, all of the squares have a deferred object attached to their 
mouse over event. The player wins if they can trigger all of the red squares 
before mousing over any grey squares.

You're welcome to take a look at the source and specs for this game on Github.

#### How does this work?

I use Deferred objects in two parts.

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

`source/javascripts/board.js.coffee` in function `bindBoard`

In this set of calls I attach callbacks for three cases: All safe (red) pieces 
being moused over, any red piece moused over, and any non-safe (grey) piece 
moused over. I do various actions based on any of those three events occuring.

Another section in which I use Deferred objects is in the `Timer` class. It is a 
small class so I've included it below.

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

`source/javascripts/timer.js.coffee`

When you create a new Timer, you can attach a listener for its progress, which will 
then invoke your callback every 10 millisecond with the elapsed time. This is how 
the timer on the game works, my progress callback updates the view with your 
current time.

### Resources

If you'd like to find more information about Deffered objects or other forms of 
asynchronous control flows, check out the articles below.

- [Deferred Object: jQuery API Documentation][3]
- [Futures and promises - Wikipedia][4]
- [Asynchronous Programming in JavaScript with "Promises" - MSDN][5]
- [Async.js library][6]

[1]: http://api.jquery.com/category/deferred-object/
[2]: https://github.com/spadin/futures-and-promises/tree/master/code
[3]: http://api.jquery.com/category/deferred-object/
[4]: http://en.wikipedia.org/wiki/Futures_and_promises
[5]: http://blogs.msdn.com/b/ie/archive/2011/09/11/asynchronous-programming-in-javascript-with-promises.aspx
[6]: https://github.com/caolan/async
[7]: http://sa.ndropad.in/futures-and-promises/code/
[8]: http://api.jquery.com/jQuery.ajax/#jqXHR
