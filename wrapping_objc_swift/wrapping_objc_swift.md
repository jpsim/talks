slidenumbers: true

# Lessons Learned Wrapping an Objective-C Framework in Swift

## NSLondon

### JP Simard, *[@simjp](https://twitter.com/simjp)*, *[realm.io](http://realm.io)*

^Notes
- Who am I?
- What is Realm?

---

# [fit] Why?

^Notes
- Why wrap an Objective-C framework in Swift?
- Why go through the trouble when you can call into Objective-C from Swift?

---

# Why?

## API Improvements

```swift
// Go from this:
func objcFunc(a: AnyObject!, b: NSArray!) -> NSString!
// to this:
func swiftFunc(a: ClassA?, b: [Int]) -> String?

// Or using autoclosures, generics, 
// default parameter values, making types
// and optionality explicit, etc.
```

^Notes
- Apple has tools for optional conformance. We don't.
- If we had sufficiently capable LLVM annotations, this wouldn't be as necessary.

---

# Why?

## To Expose Unmappable Interfaces

```objc
// Objective-C variable arguments aren't exposed to Swift
+ (RLMResults *)objectsWhere:(NSString *)format, ...;
// neither are #defines
#define NSStringFromBool(b) (b ? @"YES" : @"NO")
// or certain declarations
NSVariableStatusItemLength
```

---

# Why Not Rewrite in Swift?

1. Lazy
2. No significant gains from the language
3. Existing codebase complex and/or mature
4. Yup, still lazy

^Notes
- Even Apple frameworks are never 100% Objective-C, their API's are just exposed that way

---

# Porting an API

```
RLMObject                           // ObjC
Realm.Object                        // Swift
RLMObject.allObjects()              // ObjC
objects<T: RLMObject>(type: T.Type) // Swift
```

^Notes
- Learn to accept namespacing
- Still not completely bullet-proof (module names can still collide)

---

# Distribution

1. Dynamic framework logical
2. Can't statically link Objective-C framework in Swift framework (no modules)

---

# Exposing Just the Right Interfaces

---

# Exposing Just the Right Interfaces

## Making sure Objective-C is still importable

1. Module Map needs to be preserved
2. Must be a dynamic framework

^Notes
- Even though it should technically be possible to use a statically linked framework as a module with the appropriate module map, we haven't been able to make that work in practice.

---

# Exposing Just the Right Interfaces

## Exposing private interfaces just for Swift binding

> Unfortunately bridging headers don't work for framework targets

---

# Exposing Just the Right Interfaces

## Exposing private interfaces just for Swift binding

```
framework module Realm {
    umbrella header "Realm.h"

    export *
    module * { export * }

    explicit module Private {
        header "RLMRealm_Private.h"
    }
}
```

^Notes
- It's possible that your Swift wrapper will still need to access some internal code not exposed in the public interface
- Must create a new module map with the private things

---

# Testing

1. Don't test functionality, test interfaces
2. Write equivalency tests

^Notes
- The core functionality should only be tested once, to avoid duplication
- Interfaces should be tested
- Equivalency tests should be used to confirm that the wrapper works identically to the core

---

# Documentation

1. Compare Objective-C & Swift interfaces side by side
2. Copy docs from Objective-C
3. Convert doxygen format to ReST

^Notes
- Jazzy

---

# Links

* This talk: *[github.com/jpsim/talks](https://github.com/jpsim/talks)*
* Realm/RealmSwift: *[github.com/realm/realm-cocoa](https://github.com/realm/realm-cocoa)*
* jazzy: *[github.com/realm/jazzy](https://github.com/realm/jazzy)*

---

# [fit] **Thank You!**

---

# [fit] `NSLondon().questions?.askThem!`

## JP Simard, *[@simjp](https://twitter.com/simjp)*, *[realm.io](http://realm.io)*
