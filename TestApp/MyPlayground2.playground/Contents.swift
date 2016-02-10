//: Playground - noun: a place where people can play

import UIKit

//------------------------------------------------------------------------------------------------------------------------------------
//Sdubclassing

class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    
    func makeNoise() {
        // do nothing - an arbitary vehicle doesn't necessarily make noise
    }
}

let someVehicle = Vehicle()
print("Vehicle: \(someVehicle.description)")



class Bicycle: Vehicle {
    var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true

bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")



class Tandem: Bicycle {
    var numberOfPassengers = 0
}

let tandem = Tandem()
tandem.numberOfPassengers = 2
tandem.hasBasket = true
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")


//------------------------------------------------------------------------------------------------------------------------------------
//Overriding

class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

let train = Train()
train.makeNoise()




class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")




class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

let automaticCar = AutomaticCar()
automaticCar.currentSpeed = 35.0
print("AutomaticCar: \(automaticCar.description)")


//------------------------------------------------------------------------------------------------------------------------------------
//Initializers

struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}

var f = Fahrenheit()
print("The default temparature is \(f.temperature) Fahrenheit")

struct Fahrenheit2 {
    var temperature = 32.0 //Better way of initializing the variable with a default value
}


struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.y - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size) //do this so you don't have to re-write the code for the basic initialization
    }
}

let basicRect = Rect()
let originRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))


class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    convenience init() { //Convenience initialzers only call other initializers in the same class, where as designated initializers either perform the top-most initilaization or call a superclasses initialization. A convenience initializer never calls a superclasses initializer.
        self.init(name: "[Unamed]")
    }
}

let namedMeat = Food(name: "Soy Bacon")

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    
    override convenience init(name: String) { //overriding Food's name initializer and making it a convenience method of the RecipeIngredient class
        self.init(name: name, quantity: 1) //calls self designated initializer, which then calls the super's designated initialzer
    }
}

let oneMysteryItem = RecipeIngredient() //You can do this becuase ReceipeIngredient inherits all of the initializers from Food, and so instead of it calling self.init(name:) in Food, it calls the overriden method in RecipeIngredient, since it is inhereted and overriden
let oneBacon = RecipeIngredient(name: "Soy Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)


class ShoppingList: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

var breakfastList = [
    ShoppingList(),
    ShoppingList(name: "Soy Bacon"),
    ShoppingList(name: "Eggs", quantity: 6)
]

breakfastList[0].name = "Orange Juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

//------------------------------------------------------------------------------------------------------------------------------------
//Forced Initialization Failures in Structs
struct Animal {
    let species: String
    init?(species: String) {
        if (species.isEmpty) {
            return nil
        }
        self.species = species
    }
}

let someCreature = Animal(species: "Giraffe");

if let giraffe = someCreature {
    print("an animal was initalized with a species of \(giraffe.species)")
}

let anonymousCreature = Animal(species: "")
if anonymousCreature == nil { //initialization failed due to an empty string for a name
    print("The anonymous creature could not be initialized")
}

//Forced Initialization Failures in Enums
enum TemperatureUnit {
    case Kelvin, Celcius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celcius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}
let fahrenheitUnit = TemperatureUnit(symbol: "F");
if fahrenheitUnit != nil {
    print("This is a defined temparature unit, so initialization succedded");
}
let unknownUnit = TemperatureUnit(symbol: "X");
if unknownUnit == nil {
    print("This is not a defined tempareture unit, so initiazation failed");
}

//Forced Intialization Failures in Enums with RawValues
enum TemperatureUnit2: Character {
    case Kelvin = "K", Celcius = "C", Fahrenheit = "F"
}

let fahrenheitUnit2 = TemperatureUnit2(rawValue: "F");
if fahrenheitUnit2 != nil {
    print("This is a defined temperature unit, so initialization succeeded")
}
let unknownUnit2 = TemperatureUnit2(rawValue: "X");
if unknownUnit2 == nil {
    print("This is not a defined temperature unit, so initialization failed")
}

//Forced Initialization Failures in Classes (Must set ALL stored properties have been set!!)
class Product {
    let name: String!
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}

class CartItem: Product {
    let quantity: Int!
    init?(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name);
        if quantity < 1 {
            return nil
        }
    }
}

//Delegating failures to superclass
if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}

if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
}
else {
    print("Unable to initialize zero shirts")
}

class Document {
    var name: String?
    
    init() { }
    
    init?(name: String) {
        self.name = name
        if name.isEmpty {
            return nil;
        }
    }
}

class AutomaticallyNamedDocument: Document {
    //both init's don't go through the failable init, because this override should never fail
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    
    override init?(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Undefined]"
        }
        else {
            self.name = name
        }
    }
}

class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!
    }
}

struct Checkerboard {
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...10 {
            for j in 1...10 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    
    func squareIsBlackatRow(row: Int, columm: Int) -> Bool {
        return boardColors[(row * 10) + columm]
    }
}

let board = Checkerboard()
print(board.squareIsBlackatRow(0, columm: 1))
print(board.squareIsBlackatRow(9, columm: 9))


//------------------------------------------------------------------------------------------------------------------------------------
//Deallocation

class Bank {
    static var coinsInBank = 10_000
    static func vendCoins(var numberOfCoinsToVend: Int) -> Int {
        numberOfCoinsToVend = min(numberOfCoinsToVend, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receiveCoins(coins: Int) {
        coinsInBank += coins
    }
}

class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.vendCoins(coins)
    }
    func winCoins(coins: Int) {
        coinsInPurse += Bank.vendCoins(coins)
    }
    deinit {
        Bank.receiveCoins(coinsInPurse)
    }
}


var playerOne: Player? = Player(coins: 100)
print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
print("There are now \(Bank.coinsInBank) coins left in the bank")

playerOne!.winCoins(2_000)
print("Player one won 2000 coins and now has \(playerOne!.coinsInPurse) coins")
print("The bank now only has \(Bank.coinsInBank) coins left")

playerOne = nil //Here the player object is deallocated and the coins are returned to the bank just before the memory is released
print("Player one has left the game")
print("The bank now has \(Bank.coinsInBank) coins")


//------------------------------------------------------------------------------------------------------------------------------------
//Weak reference type (to avoid strong reference cycle) (both types are allowed to be nil at some point)

class Person {
    let name: String
    init(name: String) {
        self.name = name
    }
    var apartment: Apartment?
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
    weak var tenant: Person?
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john

john = nil
unit4A = nil

//Unowned reference type (one type can be nil, the other cannot be nil)
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number;
        self.customer = customer;
    }
    deinit {
        print("Card #\(number) is being deinitialzed")
    }
}

var johnny: Customer?
johnny = Customer(name: "Johnny Appleseed")
johnny!.card = CreditCard(number: 1234_5678_9012_3456, customer: johnny!)

johnny = nil

//Unowned reference and implicitly unwrapped optiona (both instances cannot be nil)
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

var country = Country(name: "Canada", capitalName: "Ottawa");
print("\(country.name)'s capital city is called \(country.capitalCity.name)")


//Strong reference cycle in block statement inside a class
class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: Void -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        }
        else {
            return "<\(self.name)>";
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var paragragh: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragragh?.asHTML())
paragragh = nil


//------------------------------------------------------------------------------------------------------------------------------------
//Optional Chaining

class Person2 {
    var residence: Residence?
}

class Residence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        } else {
            return nil
        }
    }
}

let john2 = Person2()

//will fail while residence is nil
if let roomCount = john2.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

//will fail while residence is nil
let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
john2.residence?.address = someAddress

//will fail while residence is nil
if (john2.residence?.address = someAddress) != nil {
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")
}

//will fail while residence is nil
if let firstRoomName = john2.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}

john2.residence?[0] = Room(name: "Bathroom")

let johnsHouse = Residence()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
john2.residence = johnsHouse

if let firstRoomName = john2.residence?[0].name {
    print("The first room name is \(firstRoomName)")
}
else {
    print("Unable to retrieve the first room name")
}


//Optional Subscript Chaining
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0]++
testScores["Brian"]?[0] = 72

if (testScores["Brain"]?[0] = 72) != nil {
    print("Variable set");
}
else {
    print("Variable not set!")
}

if let johnStreet = john2.residence?.address?.street {
    print("John's street name is \(johnStreet)")
}
else {
    print("Unable to retrieve address")
}

//Set the address and street properties so you can access them now
let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Lauren Street"
john2.residence?.address = johnsAddress

if let johnStreet = john2.residence?.address?.street {
    print("John's street name is \(johnStreet)")
}
else {
    print("Unable to retrieve address")
}

if let buildingIdentifier = john2.residence?.address?.buildingIdentifier() {
    print("Johns building identifier is \(buildingIdentifier)")
}


















































