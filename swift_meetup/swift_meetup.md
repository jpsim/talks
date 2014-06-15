# [fit] Swift

![](media/map.jpg)

## *Uncharted Territory*

^Notes
- Excited to start conversation with you
- Right now, no one knows a whole lot about Swift
- other than a few ppl at Apple, such as...

---

# Chris Lattner

![](media/lattner.jpg)

^Notes
- Only person in the world with 4 years Swift experience
- Couldn't get him to talk today, so...

---

# Chris Lattner

![](media/lattner.jpg)

### ![inline](media/llvm.png) LLVM

^Notes
- Only person in the world with 4 years Swift experience
- Couldn't get him to talk today, so...

---

# Chris Lattner

![](media/lattner.jpg)

### ![inline](media/llvm.png) LLVM
### ![inline](media/swift.png) Swift

---

# Chris Lattner

![](media/lattner.jpg)

### ![inline](media/llvm.png) LLVM
### ![inline](media/swift.png) Swift
### :+1: Handsome

---

# Stuck With *Me*

JP Simard
*[@simjp](https://twitter.com/simjp)*
*[realm.io](http://realm.io)*

![inline](media/realm.png)

^Notes
- Work at Realm, building a fast database for iOS
- Work on ObjC binding, and now Swift
- Thanks for organizing and supporting this thriving community!

---

# This Talk

1. Early, incomplete version of a language? ![](media/check.png)
2. Buggy, pre-release compiler, IDE, OS? ![](media/check.png)
3. Unreleased beta of presentation app? ![](media/check.png)
4. Presenter who doesn't fully understand the language? ![](media/check.png)

---

# [fit] What could *possibly* go wrong?

![autoplay-mute-loop](media/what_could_possibly_go_wrong.mp4)

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

![inline](media/type_inference.png)

#### Like Rust & Scala

^Notes
- Read through comments

---

# Closures

![inline](media/closures.png)

#### Swift Closures :point_right: ObjC Blocks

^Notes
- capture and store references to variables and constants

---

# Tuples

![inline](media/tuples.png)

#### Like Haskell & Scala

^Notes
- Notice the wonderful type inference at play here

---

# Super-Enums\*

![inline](media/structs.png)

#### \*Ok, not exactly the *correct* technical term

---

# Functional programming

![inline](media/functional.png)

#### Like Haskell, Scala & many others

^Notes
- There's a lot more than functional concepts in this slide:
- type inference and closures to name a few

---

# Generics

![inline](media/generics1.png)
![inline-50%](media/generics2.png)

#### Like... uh... *every* modern language!

---

### Q: What happened to my beloved
# _\*_

---

* *concepts* are still there: reference types and value types
* pointers still exist to interact with C APIs: `UnsafePointer<T>`
* C APIs are still usable:

![inline](media/keychain.png)

^Notes
- Sometimes if feels good to ditch C

---

# Demo #1

![inline](media/xcode.png)

^Notes
- Build a quick Swift app

---

# Q: How does it all *work*?

---

# **A: it *barely* does :wink:**

![inline](media/sourcekit-terminated.png)

---

# Seriously, how does it *work*?

* Swift objects are actually Objective-C objects\*
* \*Without any *methods* or *properties*... strange!
* Just like C++, Swift methods are listed in a *vtable*
* Swift properties are *ivars* with Swift methods
* ivars have no type encoding!!! `ivar_getTypeEncoding(); // always NULL`

^Notes
- Under the hood, Swift object is a valid ObjC object
- Slightly strange ObjC objects

---

# Demo #2

![inline](media/hopper.png)

^Notes
- Demo will show how Swift is compiled and works under the hood
- Show reflect(), NSStringFromClass and Hopper dissassembly

---

# Xcode & Tools Integration

* Clang knows absolutely *nothing* about Swift
* Swift compiler talks to clang through *XPC*

![inline](media/bin.png)

<sub>`/Applications/Xcode6-Beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin`</sub>

^Notes
- All about intermediary Swift compiler
- XPC is technology allowing inter-process communication on OSX

---

# Demo #3

![inline](media/xcode.png)

^Notes
- Show some of the internal tools Xcode uses
- Show how jazzy can autogenerate Swift headers from Objective-C source

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

<sub>Apple Developer Account Required</sub>

---

# Links (*!*)

* This talk: *[github.com/jpsim/talks](https://github.com/jpsim/talks)*
* Jay Freeman's AltConf talk: *[debugging your (Swift) apps with cycript](http://www.youtube.com/watch?v=Ii-02vhsdVk)*
* ObjC/Swift doc generator: *[github.com/realm/jazzy](https://github.com/realm/jazzy)*
* Evan Swick: *[Inside Swift](http://www.eswick.com/2014/06/inside-swift)*
* Swift on *[StackOverflow](http://stackoverflow.com/questions/tagged/swift)*

---

# Thank You!

---

# [fit] `Meetup().questions?.askThem!`

#### JP Simard, *[@simjp](https://twitter.com/simjp)*, *[realm.io](http://realm.io)*
