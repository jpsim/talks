# [fit] Casualties of
# [fit] *The Great*
# [fit] **Swiftening**

### JP Simard, @simjp, realm.io

![](media/bg1.jpg)

^
Conference is about evolution.
Swift is a major part of that story.

---

![](media/realm.png)

^
I work on a mobile database for iOS and Android called Realm.
Swift looked like it would allow us to build a much nicer API than with Objective-C.

---

![autoplay-loop](media/wwdc_swift_intro.mp4)

^
When it was announced, it was introduced as the future.
An evolutionary step.

---

![autoplay-loop](media/wwdc_swift_simple.mp4)

^
We were promised simplicity.

---

![autoplay-loop](media/wwdc_swift_safety.mp4)

^
We were promised safety.

---

![autoplay-loop](media/wwdc_swift_blimp.mp4)

^
We were promised time traveling blimps.

---

# Conspicuously Missing Features

1. Runtime Introspection
2. Method Swizzling
3. Key-Value Observing (KVO)
4. Key-Value Coding (KVC)
5. Runtime Manipulation of Methods & Classes
6. Invocations
7. Message proxying
8. Selectors

^
But when we started working with it, once the hype toned down...
as ObjC developers, we started trying to do "real work", and noticed all the holes.

---

# [fit] Translated ObjC
# *VS*
# [fit] Swift ML

^
As Andy Matuschak likes to call it.
ML stands for metalanguage and is the mother of functional programming invented in the 1970's.
OCAML is an ML, it inspired Haskell, etc.

---

![autoplay-loop](media/balance.mp4)

^
As we're going through this evolution, it'll be painful at times and we'll struggle to find our balance.

---

# [fit] 1. Runtime Introspection

![](media/bg2.jpg)

---

# [fit] Your six options for runtime introspection

1. Avoid it. (Stick with compile-time types & constraints)
2. Apply dynamic casting
3. Leverage Swift's **`MirrorType`** 
4. Abuse Objective-C's runtime
5. Use private functions
6. Resort to inspecting memory layout

^
- You might have noticed that this list gets progressively worse
- You should generally attempt to use the approaches in the order I've presented them, moving on to a following one if it proves to be insufficient
- I also call this list...

---

# [fit] The six degrees of **evil**

1. Avoid it. (Stick with compile-time types & constraints) – :+1:
2. Apply dynamic casting – :ok_hand:
3. Leverage Swift's **`MirrorType`** – :confused:
4. Abuse Objective-C's runtime – :grimacing:
5. Use private functions – :fearful:
6. Resort to inspecting memory layout – :scream:

---

# [fit] **Compile-time**
# [fit] **Types & Constraints**

^Notes
- Approach 1
- "Friendliest" of approaches
- AKA "Find another way"
- Let's look at Swift projects that probably would have used reflection had they been written in ObjC, but found another way

---

# QueryKit

```swift
struct MyStruct {
  let intProp: Int

  struct Attributes {
    static let intProp = Attribute<Int>("intProp")
  }
}

// Usage
let intProp = MyStruct.Attributes.intProp
intProp > 0 // NSPredicate("intProp > 0"), typesafe
```

^Notes
- Require the user to explicitly mark properties
- Typesafe, but risks getting out of date
- Could use code-generation, e.g. with SourceKitten
- Compile-time

---

# Argo

```swift
extension User: JSONDecodable {
  static func create(name: String)(email: String?)(role: Role)
                    (friends: [User]) -> User {
    return User(name: name, email: email, role: role, friends: friends)
  }

  static func decode(j: JSONValue) -> User? {
    return User.create
      <^> j <| "name"
      <*> j <|? "email" // Use ? for parsing optional values
      <*> j <| "role" // Custom types conforming to JSONDecodable work
      <*> j <|| "friends" // parse arrays of objects
  }
}
```

^Notes
- Requires some manual work
- Compile-time

---

# [fit] **Dynamic**
# [fit] **Casting**

^Notes
- Approach 2
- Substitute for instance reflection

---

# [fit] `as?`

---

```swift
protocol XPCConvertible {}

extension Int64: XPCConvertible {}
extension String: XPCConvertible {}

func toXPC(object: XPCConvertible) -> xpc_object_t? {
  switch(object) {
    case let object as Int64:
      return xpc_int64_create(object)
    case let object as String:
      return xpc_string_create(object)
    default:
      fatalError("Unsupported type for object: \(object)")
      return nil
  }
}
```

^Notes
- Using the `as?` keyword, we can fork our code depending on the type we're detecting
- You need to know all the types you want to support ahead of time
- Requires an instance
- The question mark is implicit here

---

# [fit] **Official**
# [fit] **Swift**
# [fit] **Reflection**

^Notes
- Approach 3

---

```swift
/// The type returned by `reflect(x)`; supplies an API for runtime reflection on `x`
protocol MirrorType {
    /// The instance being reflected
    var value: Any { get }
    /// Identical to `value.dynamicType`
    var valueType: Any.Type { get }
    /// A unique identifier for `value` if it is a class instance; `nil` otherwise.
    var objectIdentifier: ObjectIdentifier? { get }
    /// The count of `value`\ 's logical children 
    var count: Int { get }
    subscript (i: Int) -> (String, MirrorType) { get }
    /// A string description of `value`.
    var summary: String { get }
    /// A rich representation of `value` for an IDE, or `nil` if none is supplied.
    var quickLookObject: QuickLookObject? { get }
    /// How `value` should be presented in an IDE.
    var disposition: MirrorDisposition { get }
}
```

^Notes
- Taken from the Swift standard library

---

```swift
struct MyStruct {
    let stringProp: String
    let intProp: Int
}

let reflection = reflect(MyStruct(stringProp: "a", intProp: 1))

for i in 0..<reflection.count {
    let propertyName = reflection[i].0
    let value = reflection[i].1.value
    println("\(propertyName) = \(value)")
    if let value = value as? Int {
        println("int")
    } else if let value = value as? String {
        println("string")
    }
}

// stringProp = a
// string
// intProp = 1
// int
```

^Notes
- Need to cover all possible types by hand. Sometimes impractical.

---

# [fit] **Objective-C**
# [fit] **Runtime**

^Notes
- Approach 4
- It turns out that Swift classes are *almost* exactly like Objective-C classes under the hood

---

```swift
import Foundation

class objcSub: NSObject {
    let string: String?
    let int: Int?
}

var propCount: UInt32 = 0
let properties = clazz_copyPropertyList(objcSub.self, &propCount)

for i in 0..<Int(propCount) {
    let prop = properties[i]
    String.fromCString(property_getName(prop))! // => "string"
    String.fromCString(property_getAttributes(prop))! // => "T@,N,R,Vstring"
}
```

^Notes
- This only works on classes, which inherit from an objc class, and for properties that can be represented by the objc runtime
- It doesn't even work with `Int?` because Objective-C can't represent nil primitives

---

# [fit] **Using**
# [fit] **Private**
# [fit] **Functions**

^Notes
- Approach 5

---

```bash
nm -a libswiftCore.dylib | grep "stdlib"

> ...
> __TFSs28_stdlib_getDemangledTypeNameU__FQ_SS
> ...
> _swift_stdlib_conformsToProtocol
> _swift_stdlib_demangleName
> _swift_stdlib_dynamicCastToExistential1
> _swift_stdlib_dynamicCastToExistential1Unconditional
> _swift_stdlib_getTypeName
> ...
```

^Notes
- Let's take a look at the Swift stdlib's private functions to see if anything can help us

---

```swift
struct MyStruct {
    let stringProp: String
    let intProp: Int
}

let reflection = reflect(MyStruct(stringProp: "a", intProp: 1))

for i in 0..<reflection.count {
    let propertyName = reflection[i].0
    let value = reflection[i].1.value
    println("\(propertyName) = \(value)")
    println(_stdlib_getDemangledTypeName(value))
}

// stringProp = a
// Swift.String
// intProp = 1
// Swift.Int
```

^Notes
- Same example as earlier, but without having to hardcode every possible type

---

# [fit] **Inspecting**
# [fit] **Memory**
# [fit] **Layout**

^Notes
- Approach 6. The final and evilest of them all.

---

![autoplay](media/lattner.mp4)

^Notes
- Chris Lattner will find you
- He will make your Xcode crash... even MORE

---

```c
struct _swift_data {
    unsigned long flags;
    const char *className;
    int fieldcount, flags2;
    const char *ivarNames;
    struct _swift_field **(*get_field_data)();
};

struct _swift_class {
    union {
        Class meta;
        unsigned long flags;
    };
    Class supr;
    void *buckets, *vtable, *pdata;
    int f1, f2; // added for Beta5
    int size, tos, mdsize, eight;
    struct _swift_data *swiftData;
    IMP dispatch[1];
};
```

^Notes
- Found by inspecting the layout of Swift types in a dissassembler
- Dangerous, but powerful & accurate
- Is likely to break at any given time, but there's a tiny bit of safety since the Swift runtime is embedded in apps

---

```swift
class GenericClass<T> {}

class SimpleClass: NSObject {}

class ParentClass {
    let boolProp: Bool? // Optionals
    let intProp: Int    // Without default value
    var floatProp = 0 as Float // With default value
    var doubleProp = 0.0
    var stringProp = ""
    var simpleProp = SimpleClass()
    var genericProp = GenericClass<String>()
}
```

^Notes
- This approach will work with anything you throw at it

---

```json
{
  "boolProp": "b",
  "intProp": "i",
  "floatProp": "f",
  "doubleProp": "d",
  "stringProp": "S",
  "simpleProp": "ModuleName.SimpleClass",
  "genericProp": "[Mangled GenericClass]"
}
```

^Notes
- As much info as you'd ever need

---

# [fit] 2. Method swizzling

![](media/bg3.jpg)

---


```swift
var _greet: String -> String = { "Hello, \($0)" }
struct Conf {
    let name: String

    func greet() -> String {
        return _greet(name)
    }
}

let nsnorth = Conf(name: "NSNorth")
nsnorth.greet() // => Hello NSNorth
_greet = { _ in "nope" } // Avoiding Georgia's advice
nsnorth.greet() // => nope
```

^
Not really necessary with closures. This works with non-ObjC types.

---

# [fit] 3. Key-Value Observing (KVO)

![](media/bg4.jpg)

---

```swift
struct NSNorth {
    var speakers: [String] {
        didSet {
            println("NSNorth changed their speakers")
        }
    }

    init(speakers: [String]) {
        self.speakers = speakers
    }
}

var nsnorth = NSNorth(speakers: existingSpeakers)
nsnorth.speakers += ["Rob Rix"]
// => prints "NSNorth changed their speakers"
```

^
Requires knowing which properties you want to override at compile time.

---

# [fit] 4. Key-Value Coding (KVC)

![](media/bg5.jpg)

---

# [fit] KVC in Objective-C
# ⁣
# Dynamic Getter
# [fit] `-[NSObject valueForKey:]`
# ⁣
# Dynamic Setter
# [fit] `-[NSObject setValue:forKey:]`

^
In Objective-C, you can easily create dynamic setters and getters at runtime.

---

# Lenses in Swift

```swift
struct Conference {
    let name: String
    let year: Int
}

struct Lens<A, B> {
    let from: A -> B
    let to: (B, A) -> A
}

let year = Lens(from: { $0.year }, to: {
    Conference(name: $1.name, year: $0)
})

let nsnorth2 = Conference(name: "NSNorth", year: 2014)
let nsnorth3 = year.to(2015, nsnorth2) // => Conference(name: "NSNorth", year: 2015)
```

^
In Swift, that's a little harder, but you can use lenses instead.

---

# [fit] Giving Up

![](media/bg6.jpg)

^
There comes a time when you have to ask yourself if "pure Swift" is worth it.

---

# [fit] `dynamic`
# [fit] `@objc`
# [fit] `@NSManaged`

^
Big caveat, it doesn't work with types that can't be represented in ObjC

---

# These "cheat codes" re-enable Objective-C behaviour

* Dynamic Introspection
* Dynamic Method Dispatch
* KVO
* KVC
* Message Proxying
* Swizzling

---

# Lots more!
#### (that you "can't" do)

- C++ interop
- preprocessor
- documentation
- test coverage
- clang format
- other tooling

^
C++: wrap it in ObjC or use `extern 'C'`
Preprocessor: use codegen instead
Documentation: jazzy
Test coverage: ???

---

# [fit] What do we *do* about this?

![](media/bg7.jpg)

---

# [fit] Swift is a moving target

^
These solutions may be temporary and we'll redo this work when Swift 2.0 is inevitably released.

---

# [fit] Embrace Constraints

^
Some of these "solutions" are really just neat hacks, brittle, that go against the language's idioms and make code much more complex and harder to reason about.

---

# [fit] `NSNorth().questions.ask()!`

## JP Simard, @simjp, realm.io

![](media/bg8.jpg)
