//: Playground - noun: a place where people can play

import UIKit


class NamedShape {
    var numberOfSides: Int = 0;
    var name: String
    
    init(name: String) {
        self.name = name;
    }
    
    func simpleDescription() ->String {
        return "A shape with \(numberOfSides) sides"
    }
}




class Square: NamedShape {
    var sideLength: Double
    
    init (sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    func area() -> Double {
        return sideLength * sideLength
    }
    
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}

let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()


class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0
    
    init (sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }
    
    var perimeter: Double {
        get {
            return 3.0 * sideLength
        }
        set {
            sideLength = newValue / 3.0
        }
    }
    
    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}

var trianlge = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(trianlge.perimeter)
trianlge.perimeter = 9.9
print(trianlge.sideLength)

class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
        }
    }
    var square: Square {
        willSet {
            trianlge.sideLength = newValue.sideLength
        }
    }
    
    init(size: Double, name: String) {
        //This initializes the square variable, which is a Square class, which the squarec class is a subclass of NamedShape
        square = Square(sideLength: size, name: name)
        
        //This initializes the triangle variable, which is a Equilateral Triangle class, which the equilateral triangle class is a subclass of NamedShape
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}

var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test")
print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.square.sideLength)

let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength


//-----------------------------------------------------------------------------------------------------------------------------------

class Counter {
    var count: Int = 0;
    
    func incrementBy(amount: Int, numberOfTimess times: Int) {
        count += amount * times;
    }
}

var counter = Counter()
counter.incrementBy(2, numberOfTimess: 7)

//-----------------------------------------------------------------------------------------------------------------------------------
//Enum


enum ServerResponse {
    case Result(String, String)
    case Error(String)
}

let success = ServerResponse.Result("6:00 am", "8:09 pm")
let failure = ServerResponse.Error("Out of cheese")

switch success {
case let .Result(sunrise, sunset):
    let serverResponse = "Sunrise is at \(sunrise) and sunset is at \(sunset)."
case let .Error(error):
    let serverResponse = "Failure... \(error)"
}

enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func simpleDescription() -> String {
        //switch within a switch
        switch self {
        case .Ace:
            return "ace";
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

let ace = Rank.Ace
let description = Rank.Ace.simpleDescription()
let aceRawValue = ace.rawValue

//If you can assigned a 'Rank' value of 3 (meaning there is a value of 3 in the enum of Rank), then enter the if statement, and you can also use that variable in the function!
if let convertedBank = Rank(rawValue: 3) {
    let threeDescription = convertedBank.simpleDescription()
}


enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
    
    func color() -> String {
        switch self {
        case .Spades, .Clubs:
            return "black"
        case .Hearts, .Diamonds:
            return "red"
        }
    }
}
let hearts = Suit.Hearts
let heartDescription = hearts.simpleDescription()
let color = hearts.color()

//-----------------------------------------------------------------------------------------------------------------------------------
//struct

struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}
let threeOfSpades = Card(rank: .Three, suit: .Spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

//-----------------------------------------------------------------------------------------------------------------------------------
//Classes & protocols

protocol ExampleProtocol {
    var simpleDescription: String { get } //this is just a variable
    mutating func adjust() //this is just a function that needs to be declared in the class/struct/etc, so it doesn't have a body her
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += " Now 100% adjusted"
    }
}
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription

//confirming to the protocol just means that it must include the functions that are defined in the protocol
struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}

var b = SimpleStructure()
b.adjust()
let bDescription = b.simpleDescription


//-----------------------------------------------------------------------------------------------------------------------------------
//Extensions

extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    
    mutating func adjust() {
        self += 42
    }
}
print(7.simpleDescription)

extension Double {
    mutating func absoluteValue() {
        if (self < 0) {
            self *= -1
        }
    }
}

var d: Double = -3.27
d.absoluteValue()


//When you work with values whos type is a protocol type methods outside the protocol definition are not available, meaning you can only use what's declared in the protocol!
let protocolValue: ExampleProtocol = a;
print(protocolValue.simpleDescription);
//print(protocolValue.anotherProperty) //This will give an error because even though is a in the SimpleClass, it is not defined in the protocol


//-----------------------------------------------------------------------------------------------------------------------------------
//Generics

func repeatItem<Item>(template item: Item, timesToRepeat numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}

repeatItem(template:"knock", timesToRepeat: 4)

//reimplement the swift standard library's optional type
enum OptionalValue<Wrapped> {
    case None
    case Some(Wrapped)
}

var possibleInteger: OptionalValue<Int> = .None
possibleInteger = .Some(100)

var possibleDouble: OptionalValue<Double> = .None
possibleDouble = .Some(200)


//requirements of generic class
func anyCommonElements <T: SequenceType, U: SequenceType where T.Generator.Element: Equatable, T.Generator.Element == U.Generator.Element> (lhs: T, _ rhs: U) -> Bool {
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}

anyCommonElements([1, 2, 3], [3])


print("test", "t", "test", separator: "-")
let num = UInt64.max

let largeNum = 1_000_000

typealias UserId = String
let userid: UserId = "234234-23423523525-23423-4234234"


//-----------------------------------------------------------------------------------------------------------------------------------
//Tuples

class TestTuple {
    var item: (String, Int)
    
    func getItem() -> (name: String, val: Int) {
        return ("test", 10)
    }
    
    init(aItem item: (String, Int)) {
        self.item = item
    }
}

var fa = TestTuple(aItem: ("testing", 14))
print(fa.getItem().name, fa.getItem().val, terminator: "")

enum errorOne: Int {
    case notFound = 404
    case serverError = 501
    case other = 300
    
    func getErrorValue() -> Int {
        switch self {
        case .notFound:
            return 404
        case .serverError:
            return 501
        case .other:
            return 300
        }
    }
    
    func error(e: Int) -> errorOne {
        switch e {
        case 404:
            return .notFound
        default:
            return .serverError
        }
    }
}

let httpError = (501, "Not Found")
let type: Int = httpError.0

let (statusCode, statusMessage) = httpError

let de: errorOne = errorOne(rawValue: statusCode)!

switch de {
case .notFound:
    print("test")
case .serverError:
    print("server error")
case .other:
    print("other")
}

//-----------------------------------------------------------------------------------------------------------------------------------
//Optional Values

let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
var serverResponseCode: Int? = 404
serverResponseCode = nil

if convertedNumber != nil {
    print("this variable contains a number")
}


//-----------------------------------------------------------------------------------------------------------------------------------
//Optional Binding

//this sets a temporoary variable 'actualNumber' if 'possibleNumber' can be converted to an int
if let actualNumber = Int(possibleNumber) {
    print("actual number has a value of \(actualNumber)")
}
else {
    print("\(possibleNumber) could not be converted to an Int")
}

if let firstNumber = Int("4"), secondNumber = Int("42") where firstNumber < secondNumber {
    print("\(firstNumber) < \(secondNumber)")
}

//inplicitly unwrapped optionals
let possibleString: String? = "An optional string"
let forcedString: String = possibleString!

let assummedString: String! = "An implicityly unwrapped optional string"
let implicityString: String = assummedString

if let definiteString = assummedString {
    print(definiteString)
}


//-----------------------------------------------------------------------------------------------------------------------------------
//Error Handling

func canThrowAnError() throws {
    
}

do {
    try canThrowAnError()
    //no error was thrown
}
catch {
    //error was thrown
}

func makeASandwhich() throws {
    //...
}

do {
    try makeASandwhich()
}
catch {
    
}


//-----------------------------------------------------------------------------------------------------------------------------------
//assertions

let age = -3
//assert(age >= 0, "A person's age cannot be less than 0") //Execution will stop here if the condition inside the assertion is not met


let s: Int? = nil
let m: Int? = 3

var v = s ?? m

//If the user defined color name exists (is not null) it sets to that, else it sets to the default color name)
let defaultColorName = UIColor.redColor()
var userDefinedColorName: UIColor?
userDefinedColorName = UIColor.greenColor()
var colorNameToUse = userDefinedColorName ?? defaultColorName

//-----------------------------------------------------------------------------------------------------------------------------------
//For loops
//Closed Range Operator

for index in 1...100 {
    print(index)
}

//Half-Open Range Operator

for index in 1..<100 {
    print(index)
}

//-----------------------------------------------------------------------------------------------------------------------------------
//Strings

var aString = ""
if aString.isEmpty {
    print("empty string")
}

//-----------------------------------------------------------------------------------------------------------------------------------
//Characters

for letter in "sentence".characters {
    print(letter)
}

//use the string 'append' method to concatenate a character to an existing string type

let sparklingHeart = "\u{1F496}"

aString = "testing a string"

var newString = ""
for character in aString.characters.indices {
    newString.append(aString[character])
}
print(newString)

//-----------------------------------------------------------------------------------------------------------------------------------
//Arrays

//Creating an empty array
var anArray = [Int]()

//Array with default values
var threeDoubles = [Double](count: 3, repeatedValue: 0.0)

//Adding two arrays
//Both arrays must be of the same type0
var anotherThreeDoubles = [Double](count: 3, repeatedValue: 2.5)
var sixDoubles = threeDoubles + anotherThreeDoubles

var shoppingList: [String] = ["VeganEgg", "Almond Milk"]
var shoppingList2 = ["VeganEgg", "Almond Milk"]

if shoppingList.isEmpty {
    print("shopping list is empty")
}
else {
    print("shopping list is full")
}

shoppingList.append("Baking Powder")
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]


print("shoppingList: \(shoppingList).")

//replace items from index 3-5 with these two items (subscripting)
shoppingList[3...5] = ["Bananas", "Apples"]

print(shoppingList)

shoppingList.removeLast()
print(shoppingList)

//enumerte array-----------------------------
for (index, item) in shoppingList.enumerate() {
    print(index)
}


//-----------------------------------------------------------------------------------------------------------------------------------
//Sets

var letters = Set<Character>()
letters.insert("a")

var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip Hop", "Other", "Jazz"]
var favoriteGenres2: Set = ["Rock", "Classical", "Jazz", "Hip Hop"]
favoriteGenres2.remove("Classical")
print(favoriteGenres2)

var bString: String = ""
for genre in favoriteGenres.sort() {
    bString += genre + ", "
}
print(bString)

bString = ""
for genre in favoriteGenres.sort().reverse() {
    bString += genre + ", "
}
print(bString)

if (favoriteGenres.contains("Hip Hop")) {
    print("He likes rap...too bad")
}
else {
    print("He's normal")
}

var intersectSet = favoriteGenres.intersect(favoriteGenres2).sort() //those in both set A and B

var exclusiveSet = favoriteGenres.intersect(favoriteGenres2) //those is set A or set B, but not both

var subtractSet = favoriteGenres.intersect(favoriteGenres2) //those in set A that are left over after removing those that are also in set B

var unionSet = favoriteGenres.intersect(favoriteGenres2) //combines set A and B, regardless of any being in other

if (favoriteGenres == favoriteGenres2) {
    print("both sets have the same values")
}
else {
    print("the sets are not identical")
}

if (favoriteGenres2.isSubsetOf(favoriteGenres)) {
    print("favoriteGenres2 is inside favoriteGenres")
}

if (favoriteGenres.isSupersetOf(favoriteGenres2)) {
    print("favoriteGenres2 is a subset of favoriteGenres, or you can say favoriteGenres is a superset of favoriteGenres2")
    //This means that favoriteGenres has all of the items in favoriteGenres2 in it
}

if (favoriteGenres.isDisjointWith(favoriteGenres)) {
    print("these two sets don't have anything in common")
}


//-----------------------------------------------------------------------------------------------------------------------------------
//Dictionary

//Create an empty dictionary
var nameOfIntegers = [Int: String]()

var airports = ["YYZ": "Toranto Pearsons", "DUB": "Dublin"]

//add a new item
airports["LHR"] = "London Heathrow"

//find and use an item
if let airport = airports["DUB"] {
    print("this has the airport \(airport)")
}

//update an item with a new value
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("the old value of DUB was \(oldValue)")
}

//delete an item
airports["APL"] = "Apple International"
airports["APL"] = nil

print(airports)

//remove an item
if let removedValue = airports.removeValueForKey("DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary does not contain a value for DUB.")
}

//iterate
for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}

for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}

for airportName in airports.values {
    print("Airport name: \(airportName)")
}

let airportCodes = [String](airports.keys)

let airportNames = [String](airports.values)


//-----------------------------------------------------------------------------------------------------------------------------------
//For-loops

for index in 1...5 {
    print(index)
}

//If you don't need the value, you can replace the variable with an underscore '_'
for _ in 1...5 {
    print("item")
}

for (index, item) in (1...5).enumerate() {
    print(index)
}


//-----------------------------------------------------------------------------------------------------------------------------------
//switch

var switchTest = "testing"
switch switchTest {
case "test":
    print("test")
case "teting", "testing":
    print("found it!")
case "other":
    print("other")
default:
    print("not found...")
}

//check for an interval
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
var naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")

//Tuples
//(the unerscore '_' is a wildcard)
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("(0, 0) is at the origin")
case (_, 0):
    print("(\(somePoint.0), 0) is on the x-axis")
case (0, _):
    print("(0, \(somePoint.1)) is on the y-axis")
case (-2...2, -2...2):
    print("(\(somePoint.0), \(somePoint.1)) is inside the box")
default:
    print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
}

//Value-Binding
//This basically puts the variable as a wildcard, but lets you use that variable inside the switch block
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}

//Where in a switch
//A switch case can use a where clause to check for additional conditions.
//The example below categorizes an (x, y) point on the following graph:
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}

//if you want to fallthrough a switch statement to a following case, then you must include the 'fallthrough' statement at the end




//-----------------------------------------------------------------------------------------------------------------------------------
//While Loops

//Label while loops
//This is if you have multiple loops nested inside each other, you can name the loop, then call a break or continue, etc on
//a specific loop that you specify after the break, continue, etc.
let finalSquare = 25
var board = [Int](count: finalSquare + 1, repeatedValue: 0)
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
var square = 0
var diceRoll = 0

gameLoop: while square != finalSquare {
    if ++diceRoll == 7 { diceRoll = 1 }
    switch square + diceRoll {
    case finalSquare:
        // diceRoll will move us to the final square, so the game is over
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // diceRoll will move us beyond the final square, so roll again
        continue gameLoop
    default:
        // this is a valid move, so find out its effect
        square += diceRoll
        square += board[square]
    }
}


//Guard Statement
//only executes code after guard if the statement is true. It MUST have an else statement though
//this could be used as to not put the entire function in an iff statement, or if you're missing data, gather it before coninuing
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
        
    }
    print("Hello \(name)")
}

greet(["name": "john"])


//availability
if #available(iOS 9, OSX 10.10, *) {
    // Use iOS 9 APIs on iOS, and use OS X v10.10 APIs on OS X
} else {
    // Fall back to earlier iOS and OS X APIs
}















































