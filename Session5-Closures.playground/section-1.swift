// SWIFT SESSIONS: Closures and Advanced Function Functionality
// (c) 2014 Austin Zheng
// Released under the terms of the MIT License

import Cocoa

// ------------- CLOSURES AND FUNCTION-TYPE VALUES ------------- //

// Functions in Swift are first-class citizens: they can be passed around, consumed as arguments by functions, and
//  returned by functions. Whereas Objective-C enforced a clear delineation between C function pointers and blocks,
//  Swift unifies functions and closures. A variable with a function type can be assigned a closure, a function, or a
//  method. Functions in global scope are simply named closures that wrap over no external values.

// Let's define a few functions and classes to use in our examples.

// This is a global function.
func addTwoNumbers(x: Int, y: Int) -> Int {
  return x + y
}

// This is a class with a static/class method and an instance method.
class MathHandler {
  class func multiplyTwoNumbers(x: Int, y: Int) -> Int {
    return x * y
  }
  // Some object state
  var incrementer = 0
  func addAndIncrement(x: Int, y: Int) -> Int {
    return x + y + incrementer
  }
  init(incrementer: Int) {
    self.incrementer = incrementer
  }
}

// Now, for the examples themselves.
// The following variable, 'chosenMathFunction', is a variable of function type - in this case, (Int, Int) -> Int.
// We can assign it a function...
var chosenMathFunction: (Int, Int) -> Int = addTwoNumbers
chosenMathFunction(1, 2) // returns 3 (= 1 + 2)

// We can also assign it a class method...
chosenMathFunction = MathHandler.multiplyTwoNumbers
chosenMathFunction(2, 6) // returns 12 (= 2 * 6)

// ...or an instance method...
let myMathHandler = MathHandler(incrementer: 10)
chosenMathFunction = myMathHandler.addAndIncrement
chosenMathFunction(1, 4) // returns 15 (= 1 + 4 + 10)

// ...or a closure.
chosenMathFunction = {
  // A closure that performs the modulo/remainder operation.
  (x: Int, y: Int) -> Int in
  return x % y
}
chosenMathFunction(17, 10) // returns 7 (= 17 % 10)

// Let's look at closures in more detail. Closures are enclosed by curly braces. At their most basic, they have three
//  parts:
// 1. A signature that names the arguments and the return type, identical in form to those for functions or method
//    declarations.
// 2. The 'in' keyword, which separates the signature and the body.
// 3. A body consisting of one or more statements or expressions, just like a function.
let basicClosure = {
  // A closure that checks whether the sum of two numbers is equal to the product of the two numbers.
  (this: Int, that: Int) -> Bool in
  let sum = this + that
  let product = this * that
  return sum == product
}
basicClosure(2, 2)  // returns true
basicClosure(3, 1)  // returns false

// Just as a refresher, closures *capture* (or 'close over', hence their name) variables in their scope, and can then
//  use them outside their context. Let's see a simple example of this.
// Here is a function that returns a closure that repeats any string a given number of times
func createStringRepeater(timesToRepeat: Int) -> (String) -> String {
  // Declare a closure that repeats the string a number of times
  let repeater = {
    (x: String) -> String in
    var buffer = ""
    for i in 0..<timesToRepeat {
      buffer += x
    }
    return buffer
  }
  // Return the closure to the caller
  return repeater
}

// Create a double repeater and a triple repeater.
let doubleRepeater = createStringRepeater(2)
let tripleRepeater = createStringRepeater(3)

// Try each repeater out.
doubleRepeater("haskell")
tripleRepeater("lisp")

// Note that, when we declare 'repeater' in the function, we reference 'timesToRepeat' in the newly-minted closure.
//  'timesToRepeat' is normally only valid inside the function; once we return it goes out of scope and would usually
//  be lost forever. However, the closure 'repeater' closes over the value of 'timesToRepeat' at the time the closure is
//  created, so when we invoke our double and triple string repeaters, we still have access to that value (so we know 
//  how many times to repeat). Note also that creating the triple repeater does NOT affect the value of 'timesToRepeat'
//  closed over by the double repeater earlier. Each repeater instance has its own distinct value of 'timesToRepeat'
//  that it closed over.
//
// This is the real power of a closure - the automatic ability to 'close over' and retain values within its context,
//  allowing it to use them anytime later.

// In the repeater example, the closure captured the value of 'timesToRepeat', but didn't change it - so it received a
//  COPY of the value. However, your closure can also *mutate* a captured reference. In this case, the compiler will
//  generate code such that the closure captures a REFERENCE to the value instead; it will also move the value onto the
//  heap as necessary. It is important to note that, if you CHANGE the value of a captured reference, contexts outside
//  the closure will see your changes. If you DON'T CHANGE the value of a captured reference, your closure owns its
//  very own copy of that value and will not be affected by outside changes to the captured reference.

var runningTotal = 0

// An incrementer that actually updates runningTotal's (global) value every time it is called.
let incrementer = {
  () -> Int in
  let previousTotal = runningTotal
  runningTotal++
  return previousTotal
}

// An alternative incrementer that does not affect runningTotal's value.
let politeIncrementer = {
  () -> Int in
  var localTotal = runningTotal
  return localTotal++
}

incrementer() // returns 0
incrementer() // returns 1
incrementer() // returns 2

politeIncrementer() // returns 3
politeIncrementer() // returns 3 (since runningTotal is still 2)

incrementer() // returns 3
politeIncrementer() // returns 4

// Closures are reference types, be aware. This means that you can have multiple references pointing to the same
//  closure - and so both references can see effects to the closure's state.


// ------------- SYNTACTIC SUGAR FOR CLOSURES ------------- //

// Closures have lots of options for syntactic sugar. Now that you know how basic closures work, let's examine some of
//  the options for closure sugar.

// CLOSURE SUGAR 1: If the compiler KNOWS the type of the closure - for example, the type is attached to the variable,
//  or the closure is being passed into a function as an argument, you can omit the return type, and you can name the
//  parameters in an abbreviated format without having to declare their types.
let stringRepeater: (String, Int) -> String = {
  toRepeat, numberOfTimes in
  var buffer = ""
  for i in 0..<numberOfTimes {  // (remember, ..< is the half-closed range operator in Beta 3 and possibly later)
    buffer += toRepeat
  }
  return buffer
}
// Note that the compiler knows 'toRepeat' has to be a String, and 'numberOfTimes' has to be an Int.
// This is identical to the following code:
/*
let stringRepeater = {
  (toRepeat: String, numberOfTimes: Int) -> String in
  var buffer = ""
  for i in 0..<numberOfTimes {
    buffer += toRepeat
  }
  return buffer
}
*/
// Let's try it out:
stringRepeater("hello", 3)

// CLOSURE SUGAR 1a: If the compiler KNOWS the type of the closure, and the closure doesn't take arguments at all, you
//  don't need the argument list or the 'in':
let greeterClosure: () -> String = {
  let x = "hello"
  let y = ", "
  let z = "world"
  return x + y + z
}
greeterClosure()  // returns "hello world"

// CLOSURE SUGAR 2: If the closure is supposed to return a value, and the closure body consists of a single expression,
//  you can omit the 'return' keyword.
let firstLastEqualComparer: ([Int]) -> Bool = {
  // Return true if the first and last elements of an array are the same
  someArray in
  someArray[0] == someArray[someArray.count - 1]
}
firstLastEqualComparer([1, 2, 3, 1]) // returns true
firstLastEqualComparer([1, 2, 3, 3]) // returns false

// CLOSURE SUGAR 3: If the closure has at least one argument, you can use $0 to refer to the first argument, $1 to the
//  second argument, and so forth, in lieu of naming the arguments explicitly.
let addFourNumbersClosure: (Int, Int, Int, Int) -> Int = {
  return $0 + $1 + $2 + $3
}
addFourNumbersClosure(1, 10, 100, 1000) // returns 1111

// CLOSURE SUGAR 4: If a function takes a closure as its FINAL argument, you can write the closure outside the function
//  invocation, with the open '{' following the closing ')'. 
// An example:
// 'filter' is a built-in higher-order collection operation. It takes a closure that determines whether individual
//  elements should be present in the output array. Here is how we'd invoke 'filter' normally.
var onlyEvens = [1, 2, 3, 4].filter({ $0 % 2 == 0 })
onlyEvens // [2, 4]

// The following is exactly equivalent.
onlyEvens = [1, 2, 3, 4].filter() { $0 % 2 == 0 }
onlyEvens // [2, 4]

// The point of this sugar is to make certain types of APIs more visually appealing. For example, GCD is Apple's
//  multithreading library that takes closures as work items to execute asynchronously. You can see the difference
//  between the standard and sugared invocations of a very simple 'do this after X seconds' construct. The second one
//  looks a little more like a language construct than the first one, which is the intention.
// (NOTE: don't try to run the following examples in the playground; they won't work here. If you want to see them work,
//  create a new app.)
/*
let queue = dispatch_get_main_queue()
let delta = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * NSEC_PER_SEC))
// compare
dispatch_after(delta, queue, {
  println("This happened 10 seconds later") 
})
// vs.
dispatch_after(delta, queue) {
  println("This happened 10 seconds later")
}
*/


// ------------- CURRYING ------------- //

// Currying (named after Haskell Curry, who also lent his name to three different eponymous programming languages), is
//  the process of breaking down a function that takes multiple arguments into a number of functions that each take a
//  single argument, and return another function (or the final value). An abstract example follows:
// Imagine a single function with a type signature like this:
// 
//  (a: A, b: B, c: C, d: D) -> Z.
//
// Let's curry this function. If we do so, we'd get the following functions:
//
//  (a: A) -> ((b: B) -> ((c: C) -> ((d: D) -> Z)))
//
// In more detail:
//  1. We have a single function, f, that takes 'a', and returns another function, f'.
//  2. f' is a function that takes a single argument, 'b', and returns another function, f''.
//  3. f'' is a function that takes a single argument, 'c', and returns another function, f'''.
//  4. f''' is a function that takes a single argument, 'd', and returns the final result, of type Z.
//
// We invoke the single function as following: foo(a, b, c, d). We invoke the four curried functions, as following:
//  foo(a)(b)(c)(d). If this is confusing, re-read the description and think about why it makes sense.

// Swift has sugar for currying. Let's go through a simple example.
func concatThreeNumbers(first: Int, second: Int, third: Int) -> String {
  return "\(first)\(second)\(third)"
}
concatThreeNumbers(1, 2, 3)  // returns "123", surprise

// This is a boring function, but what if we curried it manually? This is a bit tedious, but here we go.
func curryConcatThreeNumbers(first: Int) -> (Int -> (Int -> String)) {
  // (start of first closure
  let firstClosure: (Int -> (Int -> String)) = {
    second in
    // (start of second closure)
    let secondClosure: (Int -> String) = {
      third in
      return "\(first)\(second)\(third)"
    }
    return secondClosure
  }
  return firstClosure
}
let firstCurry = curryConcatThreeNumbers(1)
let secondCurry = firstCurry(2)
var finalResult: String = secondCurry(3)

// More concisely:
finalResult = curryConcatThreeNumbers(1)(2)(3)

// Fortunately, we can declare curryConcatThreeNumbers in the following way, and it'll work exactly the same! This is
//  sugar offered to us by Swift.
func betterCurryConcatThreeNumbers(first: Int)(second: Int)(third: Int) -> String {
  return "\(first)\(second)\(third)"
}
betterCurryConcatThreeNumbers(1)(second: 2)(third: 3)

// We can also partially curry the new function, just like with the original.
let partialCurry = betterCurryConcatThreeNumbers(9)
partialCurry(second: 3)(third: 4) // returns "934"
partialCurry(second: 0)(third: 8) // returns "908"
