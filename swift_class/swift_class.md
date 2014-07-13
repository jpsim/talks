# [fit] Swift

## *Class + Hackday*

^Notes
Thanks for coming!

---

# **The set up**

---

# The Setup

![inline](media/xcode.png)

Xcode6-Beta3

---

# Who *am* I?

---

# JP Simard
## *[@simjp](https://twitter.com/simjp)*
## *[realm.io](http://realm.io)*

![inline](media/realm.png)

^Notes
- Work at Realm, building a fast database for Objective-C and Swift
- Work on ObjC binding, and now Swift
- Thanks for organizing and supporting this thriving community!

---

# Today :calendar:

---

# *Class*

![](media/swift.png)

## *1. Learn about Swift*
## *2. Build an app*
## *3. Questions*

---

# Why Swift > ObjC?

* Type safety & inference
* Closures
* Tuples
* Super-Enums
* Functional programming
* Generics

^Notes
- Finally, some modern language features!
- Behind the scenes, Swift’s compiler optimizes string usage so that actual copying takes place only when absolutely necessary. This means you always get great performance when working with strings as value types.

---

# Q: What does it *look* like?

^Notes
- Notice the languages that may have inspired this at the bottom

---

# Type *safety* & *inference*

```swift
let anInt = 3
let aFloat = 0.1416
var pi = anInt + aFloat // Compile warning

pi = 3 + 0.1416
// Compiles: number literals are untyped
```

## Like Rust & Scala

^Notes
- Read through comments

---

# Closures

```swift
func backwards(s1: String, s2: String) -> Bool {
	return s1 > s2
}
sort(["b", "a"], backwards) // => ["a", "b"]
```

## Swift Closures :point_right: ObjC Blocks

^Notes
- capture and store references to variables and constants

---

# Tuples

```swift
let http404Error = (404, "Not Found")
```

## Like Haskell & Scala

^Notes
- Notice the wonderful type inference at play here

---

# Super-Enums\*

#### \*Ok, not exactly the *correct* technical term

---

```swift
enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "Spades"
        case .Hearts:
            return "Hearts"
        case .Diamonds:
            return "Diamonds"
        case .Clubs:
            return "Clubs"
        }
    }
}
```

^Notes
- Enums in Swift can have functions!

---

# Functional programming

```swift
let numbers = [1, 5, 3, 12, 2]
numbers.map {
    (number: Int) -> Int in
    return 3 * number
} // => [3, 15, 9, 36, 6]
numbers.filter {$0 % 2 == 0} // => [12, 2]
```

## Like Haskell, Scala & many others

^Notes
- There's a lot more than functional concepts in this slide:
- type inference and closures to name a few

---

# Generics

### Like... uh... *every* modern language!

---

```swift
// Reimplement the Swift standard 
// library's optional type
enum OptionalValue<T> {
	case None
	case Some(T)
}
var maybeInt: OptionalValue<Int> = .None
maybeInt = .Some(100)

// Specialized Array
var letters: [Array]
letters = ["a"]
```

---

### Q: What happened to my beloved
# _\*_

---

### Q: What happened to my beloved _\*_?

* *concepts* are still there: reference types and value types
* pointers still exist to interact with C APIs: `UnsafePointer<T>`, etc.

---

### Q: What happened to my beloved _\*_?

#### C APIs are still usable

```swift
import Foundation
import Security

let secret = "Top Secret".dataUsingEncoding(NSUTF8StringEncoding)
let dict = [kSecClass as String: kSecClassGenericPassword,
    kSecAttrService as String: "MyService",
    kSecAttrAccount as String: "Some Account",
    kSecValueData as String: secret] as NSDictionary
let status = SecItemAdd(dict as CFDictionaryRef, nil)
```

^Notes
- Sometimes if feels good to ditch C

---

# jazzy<sup>♪♫</sup>

### ![](media/octocat.png) *[github.com/realm/jazzy](media/https://github.com/realm/jazzy)*

#### a soulful way to generate docs for Swift & Objective-C

---

# Links (**)

* *[Official Swift website](https://developer.apple.com/swift)*
* *[The Swift Programming Language Book](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/)*
* *[WWDC Videos](https://developer.apple.com/videos/wwdc/2014)*
* *[WWDC Sample Code](https://developer.apple.com/wwdc/resources/sample-code)*
* *[Xcode 6](https://developer.apple.com/wwdc/resources)* (and other resources)

<sub>Free Apple Developer Account Required</sub>

---

# Links (*!*)

* This talk: *[github.com/jpsim/talks](https://github.com/jpsim/talks)*
* Jay Freeman's AltConf talk: *[debugging your (Swift) apps with cycript](http://www.youtube.com/watch?v=Ii-02vhsdVk)*
* ObjC/Swift doc generator: *[github.com/realm/jazzy](https://github.com/realm/jazzy)*
* Evan Swick: *[Inside Swift](http://www.eswick.com/2014/06/inside-swift)*
* Swift on *[StackOverflow](http://stackoverflow.com/questions/tagged/swift)*

---

# Let's build a *To-Do* app!

![inline](media/xcode.png)

---

# Thank You!

---

# [fit] `Hackday().questions?.askThem!`

---

# [fit] `Hackday().questions?.askThem!`

### JP Simard, *[@simjp](https://twitter.com/simjp)*, *[realm.io](http://realm.io)*
