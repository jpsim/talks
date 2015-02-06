slidenumbers: true

# [fit] :mag_right: Introspecting Swift :mag:
## dotSwift 2015, JP Simard, [@simjp](https://twitter.com/simjp)

^Notes
- AKA dynamic reflection

---

# [fit] **Why?**

^Notes
- Runtime introspection is a powerful tool for creating elegant and delightful API's that leverage information the program already has.
- If done right, they can also be safer than the alternatives.

---

# Mantle

```objc
@interface GHIssue : MTLModel <MTLJSONSerializing>

@property GHUser *assignee;
@property NSDate *updatedAt;

@property NSString *title;
@property NSString *body;

@property NSDate *retrievedAt;

@end
```

^Notes
- Powerful way to dynamically do things like JSON importing/mapping

---

# FCModel & Realm

```objc
@interface Employee : RLMObject

@property NSString *name;
@property NSDate *startDate;
@property float salary;
@property BOOL fullTime;

@end
```

^Notes
- Great way to define a typesafe database schema that maps naturally to language

---

# [fit] **How?**

^Notes
- Being a highly dynamic language, ObjC has fantastic support for this
- Swift by default is the very opposite of dynamic, which overall is great, but not for dynamic introspection
- So how do we do this in Swift?

---

![autoplay loop](media/swan_dive.mp4)

^Notes
- Join me for a technical swan dive into dynamic reflection of types in Swift

---

# [fit] The six ways to **introspect Swift**

1. Stick with compile-time types & constraints
2. Apply dynamic casting
3. Leverage Swift's **`MirrorType`**
4. Abuse Objective-C's runtime
5. Use private functions
6. Resort to inspecting memory layout

^Notes
- You might have noticed that this list gets progressively worse
- You should generally attempt to use the approaches in the order I've presented them, moving on to a following one if it proves to be insufficient
- I also call this list...

---

# [fit] The six degrees of **evil**

1. Stick with compile-time types & constraints – :+1:
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

![](media/sauron.jpg)

^Notes
- It's eye-of-sauron evil

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

# [fit] **Why?**

^Notes
- Why are we even doing this again?
- Runtime introspection is a powerful tool for creating elegant and delightful API's that leverage information the program already has.
- Enables really powerful API's
- If done right, they can also be safer than the alternatives

---

# RealmSwift

```swift
class Employee: Object {
  dynamic var name = "" // you can specify defaults
  dynamic var startDate = NSDate()
  dynamic var salary = 0.0
  dynamic var fullTime = true
}

class Company: Object {
  dynamic var name = ""
  dynamic var ceo: Employee? // optional
  let employees = List<Employee>()
}
```

^Notes
- Example of what we can build with introspection in Swift

---

# [fit] The six ways to **introspect Swift** 

1. Stick with compile-time types & constraints – :+1:
2. Apply dynamic casting – :ok_hand:
3. Leverage Swift's **`MirrorType`** – :confused:
4. Abuse Objective-C's runtime – :grimacing:
5. Use private functions – :fearful:
6. Resort to inspecting memory layout – :scream:

---

# Links (1/2)

* This talk: *[github.com/jpsim/talks](https://github.com/jpsim/talks)*
* Mantle: *[github.com/Mantle/Mantle](https://github.com/Mantle/Mantle)*
* FCModel: *[github.com/marcoarment/FCModel](https://github.com/marcoarment/FCModel)*
* Realm: *[github.com/realm/realm-cocoa](https://github.com/realm/realm-cocoa)*
* QueryKit: *[github.com/QueryKit/QueryKit](https://github.com/QueryKit/QueryKit)*
* Argo: *[github.com/thoughtbot/Argo](https://github.com/thoughtbot/Argo)*

---

# Links (2/2)

* Dynamic Casting: *[blog.segiddins.me](http://blog.segiddins.me/2015/01/25/dynamic-casting-in-swift)*
* SwiftXPC: *[github.com/jpsim/SwiftXPC](https://github.com/jpsim/SwiftXPC)*
* MirrorType Docs: *[swiftdoc.org/protocol/MirrorType](http://swiftdoc.org/protocol/MirrorType)*
* Russ Bishop on horrible things: *[russbishop.net](http://www.russbishop.net/swift-how-did-i-do-horrible-things)*
* Injection for Xcode: *[injectionforxcode.com](http://injectionforxcode.com)*
* SwiftIvarTypeDetector: *[github.com/jpsim/SwiftIvarTypeDetector](https://github.com/jpsim/SwiftIvarTypeDetector)*

---

# [fit] **Thank You!**

---

# [fit] `dotSwift().questions?.askThem!`

## JP Simard, *[@simjp](https://twitter.com/simjp)*, *[realm.io](http://realm.io)*
