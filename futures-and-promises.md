## Futures, Promises & Deferred Objects

Futures & promises are objects that reference a value which may (or may not) be available at some later point. The terms future, promise and delay are used interchangeably. Another name for this feature is deferred object.

One of the most widely available implementations of the promise feature is included in the jQuery library and is named [jQuery.Deferred()][1]. This article will show examples of using `jQuery.Deferred()` in common situations.

### Using deferred objects for Ajax calls

Every so often you may find yourself in a scenario where you require a certain number of operations to happen before you continue. These operations may need to happen in sequence or in any order, but they must all finish before the code can proceed.

A popular example is making multiple concurrent ajax calls and then using the returned data after all requests have completed.


	src1 = $.ajax "source-1"
	src2 = $.ajax "source-2"
	
	$.when(src1, src2).then (data1, data2) ->
		# do something with both data objects.

<small>_The code examples in this article are written in CoffeeScript which compiles down to regular JavaScript._</small>

The intent of this code reads clearly. When the two ajax calls have finished loading, execute the anonymous function. The `$.when` and `deferred.then` functions are part of the jQuery Deferred API. Also of note, `$.ajax` returns a jqXHR object, which extends the promise protocol, and is the reason it can be used as a parameter in the `$.when` function.

In the example above, the two ajax calls can occur independent of one another, however, sometimes you may need the response from the first ajax call before you can continue with the second operation. Normally, you might create a callback chain like the one below.

	$.ajax
		url: "source-1"
		success: (response1) ->
			$.ajax
				url: "source-2"
				data: { someVar: response1.someVal }
				success: (response2) ->
					$.ajax
						url: "source-3"
						data: { someVar: response2.someVal }
						success: (response3) ->
							// finally do something here

Another solution is to use a when/then chain which makes the code show less clutter.

	req1 = $.ajax
		url: "source-1"
	
	req2 = (res1) ->
		$.ajax
			url: "source-2"
			data: { someVar: res1.someVal }
	
	req3 = (res2) ->
		$.ajax
			url: "source-3"
			data: { someVar: res2.someVal }
	
	chain = $.when(req1).then(req2).then(req3)
	chain.done (res3) ->
		# finally do something here

In the example above `req1` is an `$.ajax` object whereas `req2` and `req3` are functions that return an `$.ajax` object. The distinction is very important. The `deferred.then` function expects a callback which can return a promise. If any of the ajax requests fail, the `chain.done` callback will never be triggered, just as you would expect.

<small>_Note: Callback nesting that is several levels deep is a code smell. Consider refactoring your code, deferred objects may help, but other refactoring methods may be more beneficial. Using a class-based structure is a good start._</small>

### Usefulness aside from Ajax requests

Ajax requests make for the best examples of futures because they are so commonly used. Some other cases where futures could be used include: File access, Web Workers or other asynchronous calls.

An interesting use of promises I've toyed around with is user interaction. I've embedded an example below that shows how you can combine deferred objects with mouse events to create a simple mouse dexterity game.
<!--
<iframe src="http://sa.ndropad.in/futures-and-promises/code/" frameborder="0" width="450" height="200" style="margin: 0 auto;">
	
</iframe>
-->
<div style="width: 450px; height: 200px; margin: 0 auto; border: 1px solid black; text-align: center; line-height: 200px;">
<em>web version has embedded game</em>
</div>
<small>[Play the game][7] in a new window or [view the source][2] on Github.</small>

In the example above, all of the squares have a deferred object attached to their mouse over event. The player wins if they can trigger all of the red squares before mousing over any grey squares.

### Other forms of control flow

Futures are one of many ways to control the flow of your code in an asynchronous environment. For an interesting list of other flows and examples take a look at the [Async.js library][6] on Github. This library includes common patterns for asynchronous control flow.

The series control flow allows you to run an array of functions one after the other:

	async.series([
	    function(callback){
	        // do some stuff ...
	        callback(null, 'one');
	    },
	    function(callback){
	        // do some more stuff ...
	        callback(null, 'two');
	    }
	],
	// optional callback
	function(err, results){
	    // results is now equal to ['one', 'two']
	});

<small>_JavaScript example from the Async.js Github repository._</small>

The parallel control flow allows you to run an array of functions in parallel, without having to wait until the previous function has finished:

	async.parallel([
	    function(callback){
	        setTimeout(function(){
	            callback(null, 'one');
	        }, 200);
	    },
	    function(callback){
	        setTimeout(function(){
	            callback(null, 'two');
	        }, 100);
	    }
	],
	// optional callback
	function(err, results){
	    // the results array will equal ['one','two'] even though
	    // the second function had a shorter timeout.
	});

The parallel example is very similar to the first example in this article `$.when(ajax1, ajax2).then(fn)`

The waterfall control flow allows you to run an array of functions that feed the return values into the next function in the array:

	async.waterfall([
	    function(callback){
	        callback(null, 'one', 'two');
	    },
	    function(arg1, arg2, callback){
	        callback(null, 'three');
	    },
	    function(arg1, callback){
	        // arg1 now equals 'three'
	        callback(null, 'done');
	    }
	], function (err, result) {
	   // result now equals 'done'    
	});

The waterfall example is very similar to the second example in this article `$.when(ajax1).then(fn).then(fn2)`

### Conclusion

We began this article discussing deferred objects and how to use them in JavaScript. I've laid out a few scenarios where deferred objects may be helpful, but they are not the only solution. I encourage the reader to learn more about control flows and how they help manage the complexities of asynchronous programming.

### Readers

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