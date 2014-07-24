// SWIFT SESSIONS: Basics of Swift
// (c) 2014 Austin Zheng
// Released under the terms of the MIT License

import Cocoa

// ------------- WELCOME TO SWIFT ------------- //

// Welcome to this set of Swift playgrounds, designed to gently introduce you to key Swift concepts with the aid of
//  live, functional code examples.

// First of all, comments in Swift work a lot like they do in C or C++. Use "//" to start a single-line comment.

/* Use "/*" and "*/" to start a multi-line comment.
   Unlike multi-line comments in C or C++, Swift's multi-line comments can be
   /* /* nested. */ */
*/

// Playgrounds are like a REPL - you can enter code and see immediately what happens. If you're running Xcode 6 DP 4 or
//  later, you don't need to worry about playgrounds damaging your computer - if something goes wrong, just quit Xcode
//  and check out a fresh copy of the playground.

// Semicolons are optional at the end of lines. But if you have multiple statements on the same line, the statements
//  must be separated by semicolons.


// ------------- DECLARING VARIABLES AND CONSTANTS ------------- //

// Let's create a variable.
var myFirstVariable = 0

// 'var' is used to declare a variable. A variable can be reassigned.
myFirstVariable = 1
myFirstVariable = 2
myFirstVariable = 1000

// Let's create a constant.
let myFirstConstant = "hello"

// 'let' is used to create a constant. A constant's value can't be changed.
// myFirstConstant = "world" // uncommenting this will cause the worksheet to fail...

// Swift is statically typed. It figured out what type 'myFirstVariable' and 'myFirstConstant' are by looking at the
//  values they were assigned. This is an example of TYPE INFERENCE. It shouldn't be confused with dynamic typing,
//  like in languages such as JavaScript or Python.

// Because Swift is statically typed, you can't create a variable holding an integer, and then give it a string or a
//  boolean:
// myFirstVariable = "hello" // INVALID
// myFirstVariable = false   // INVALID
// myFirstVariable = 0.321   // INVALID; there is no implicit conversion between floating-point numbers and integers

// You can explicitly state what type a variable or constant should be.
// After the name of the variable, add a ':', and then the name of the type.
var myString : String = "goodbye"
let myFloatConstant : Float = 1.2345678


// ------------- BASIC SWIFT TYPES ------------- //

// Swift has a number of basic types. The following is a non-comprehensive list.
//
// Int represents an integer:
let a : Int = -10
// UInt represents a non-negative integer:
let b : UInt = 3
// Float represents a floating-point number:
let c : Float = 3.14159
// Bool represents 'true' or 'false':
let d : Bool = false
// String represents a Unicode string of characters:
let e : String = "this is a string; 你好，世界!"
// Character represents a single character; note the use of double quotes:
let f : Character = "\n"

// There are also specific-width versions of some of these types:
let a1 : Int16 = 4
let b1 : UInt64 = 9
let c1 : Float64 = 1.1111

// What if we want to get the string representation of an integer, or the float representation of an integer? We need to
//  create new instances using the old values. Here's an example:
let someInt : Int = 12345
let myFloat : Float = Float(someInt)
let myIntString : String = String(someInt)
// (Note that C-style casting does not work in Swift. You cannot coerce an Int to a Float, for example.)

// Let's look at strings in a little more depth. You can concatenate strings using "+":
let myConcatString = "the quick " + "brown fox " + "jumps over " + "the lazy " + "dog"

// If you want to interpose another object in a string, use "\(<some expression>)" syntax, as demonstrated below:
let myMathString = "the sum of \(someInt) and \(999) is \(someInt + 999)"

// Because strings support Unicode, string length (and the distinction between characters and graphemes) is sort of
//  complicated. Refer to the Swift documentation for more details.


// ------------- PRINTING TO CONSOLE ------------- //

// Use the 'println()' function to print to the console. Note that you can't see the console in a playground unless you
//  mouse over a result in the right sidebar, and then click the circle icon.
println("bleh")


// ------------- SWIFT CONTAINERS ------------- //

// Swift also comes with two types of containers:
//
// Arrays are an ordered collection of items. Arrays are typed: you can have an Array of Strings or an Array of Ints,
//  but not a single Array that contains both types of items.
// Array literals are defined using square brackets. Each item in the array is separated by a comma.
let myFirstArray = [1, 2, 3, 4, 5]

// Dictionaries, known as maps in other languages, store key-value pairs. Each key maps to a corresponding value. Like
//  Arrays, Dictionaries are typed, according to both their keys and their values. A dictionary with String keys and
//  String values is different from a dictionary with Int keys and String values.
// Dictionary literals are defined using square brackets, with ':' separating keys from values, and ',' separating
//  key-value pairs:
let stringToStringDict = ["California" : "CA", "Delaware" : "DE", "Wyoming" : "WY"]
let intToBoolDict = [0 : false, 1 : true, 2 : false, 3 : true]

// Get the number of items in an array or dictionary using the "count" property:
myFirstArray.count        // returns 5, since there are 5 items in the array
stringToStringDict.count  // returns 3, since there are three key-value pairs

// Get an item in an array using square brackets and the 0-based index of the item you want. Note that using a negative
//  index, or an index greater than or equal to the number of items in the array, will cause a crash.
let firstItem = myFirstArray[0]             // = 1

// Get an item from a dictionary using square brackets and the desired key. Note that we place an '!' after the
//  expression; this is because a dictionary might not have the desired key, so it might return nil. More on this topic
//  in a future worksheet.
let itemInDictionary = intToBoolDict[0]!    // = false

// Note that dictionaries and arrays created using 'let' cannot be modified at all! If you want to create a mutable
//  array or dictionary, use 'var':
var myMutableArray = [1, 2, 3]

// Change the value of an array item by using square brackets. For example, let's set the first item to 100.
myMutableArray[0]         // originally 1
myMutableArray[0] = 100
myMutableArray[0]         // now 100

// Append an item to an array using 'append':
myMutableArray.append(99)
myMutableArray            // now [100, 2, 3, 99]

// Delete an item using 'removeAtIndex' or 'removeAll':
myMutableArray.removeAtIndex(1)
myMutableArray            // now [100, 3, 99], since '2' was removed
myMutableArray.removeAll(keepCapacity: true)

// For dictionaries, use square brackets to either add a new key-value pair, or replace an existing key's value with a
//  new value:
var myMutableDict = ["California" : "CC", "Delaware" : "DE"]
myMutableDict["Alabama"] = "AL"
myMutableDict["Calfornia"] = "CA"

// Remove an item using 'removeValueForKey':
myMutableDict.removeValueForKey("California")
myMutableDict   // Now, no more entry for "California"


// ------------- OPERATORS ------------- //

// As you might have surmised, Swift comes with the standard suite of C-style operators.
5 + 4       // 9
2 / 3       // 0
2.0 / 3.0   // 0.66666667
-5 % 2      // -1
var someNumber = 1
someNumber++

// See the Swift documentation for more details. A couple of notes:
//  - Arithmetic is checked by default. If your arithmetic expression's result would cause an overflow or underflow, a
//    runtime error is raised. Use the unchecked arithmetic operators, &+, &-, &*, &/, &%, to avoid this behavior.
//  - The '%' operator calculates the proper remainder for a division operation involving negative operands.


// ------------- CONTROL FLOW ------------- //

// Swift has the standard control flow structures. In most cases, parentheses around the predicates are optional, as
//  demonstrated below:

var testNumber = 10
var whileCounter = 0

// IF STATEMENTS, including optional 'else if' and 'else' clauses.
if testNumber > 5 {
  "ifTestNumber is 6 or greater"
}
else if testNumber > 1 {
  "ifTestNumber is between 2 and 5"
}
else {
  "ifTestNumber is at most 1"
}

// WHILE LOOP
while whileCounter < 10 {
  println("working!")
  whileCounter++
}

// DO-WHILE LOOP
whileCounter = 0
do {
  println("working again!")
  whileCounter++
} while whileCounter < 10

// TRADITIONAL FOR LOOP
//  (note the declaration of the loop counter variable using 'var')
for var i = 0; i < 10; i++ {
  println("counting up; i is \(i)")
}

// FOR-EACH LOOP
//  (note that type inference allows the compiler to figure out that 'a' must be a String)
let animals = ["cat", "dog", "bird", "fish", "honeybee"]
for a in animals {
  println("the current animal is \(a)")
}

// FOR-EACH LOOP WITH INDICES, by using "enumerate()"
for (index, a) in enumerate(animals) {
  println("animal number \(index + 1) is \(a)")
}

// SWITCH STATEMENTS exist, but will be covered in more detail in another worksheet.
switch testNumber {
case 0:
  println("Test number is 0")
case 10:
  println("Test number is 10")
default:
  println("Test number is something else")
}
// A couple of notes on switch statements:
// - They must be comprehensive. Provide a 'default' clause if the compiler complains.
// - Swift switch statements do NOT fall through by default. Only one of the three strings will be printed in the above
//   example, no matter what the input is. The 'fallthrough' keyword can be used to explicitly force execution to
//   continue onto the next case's code.
// - They can do far more than the traditional C-style switch statement.


// ------------- FUNCTIONS ------------- //

// Swift has functions, like many other languages.
//
// Declare a function using the 'func' keyword, followed by its name and parentheses. The function body goes inside
//  curly braces:

func doSomethingNifty() {
  println("hello")
}

// Function calls are done using the standard C conventions:
doSomethingNifty()    // calls the function

// What if we want the function to return a value? Add an "-> TypeName" after the parentheses:

func returnHelloWorld() -> String {
  return "hello world"
}

// Note that if we say our function returns a value, it MUST return a value for all possible code paths. Otherwise, the
//  compiler will complain. Comment out the "return "hello world"" statement above and see what happens.

// What if we want to pass arguments into the function? Add the arguments as demonstrated below:
//  Function arguments are separated by commas. They take the form 'argumentName : ArgumentType'.

func addThreeNumbers(firstNumber: Int, secondNumber: Int, thirdNumber: Int) -> Int {
  return firstNumber + secondNumber + thirdNumber
}

// Call this function with the appropriate arguments, just like with C or similar languages:
let mySum = addThreeNumbers(1, 2, 3)  // mySum = 6
