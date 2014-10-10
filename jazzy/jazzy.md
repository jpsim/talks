# [fit] jazzy<sup>♪♫</sup>

![](media/octocat.png)

### [fit] *[github.com/realm/jazzy](https://github.com/realm/jazzy)*

#### [fit] a soulful way to generate docs for Swift & Objective-C

---

## **Instead of parsing your source files, jazzy hooks into clang/SourceKit and uses the AST representation of your code and its comments for more accurate results.**

---

![fit](media/jazzy.jpg)

---

# [fit] How do you *USE* it?

---

# [fit] `$ [sudo] gem install jazzy`

^Notes
- Installation

---

# [fit] `$ jazzy`

^Notes
- Literally just run that in your app's directory

---

# `$ jazzy`

* Grabs all the `*.swift` files from your main target and builds docs for them
* Target & destination are configurable... more coming
* Outputs static site in `docs/` by default

---

# Design goals

* Generate source code docs matching Apple's official reference documentation
* Support for Xcode and Dash docsets
* High readability of source code comments
* Leverage modern HTML templating (Mustache)
* Let Clang/SourceKit do all the heavy lifting
* Compatibility with appledoc when possible

---

# Doxygen (ObjC-style)

```swift
/**
    Lorem ipsum dolor sit amet.

    @param bar Consectetur adipisicing elit.

    @return Sed do eiusmod tempor.
*/
func foo(bar: String) -> AnyObject { ... }
```

---

# Restructured Text (ReST)

```swift
/**
    Lorem ipsum dolor sit amet.

    :param: bar Consectetur adipisicing elit.

    :returns: Sed do eiusmod tempor.
*/
func foo(bar: String) -> AnyObject { ... }
```

---

# Getting there

---

![fit](media/swiftdoc.png)

---

# SourceKit

![inline](media/sourcekit-terminated.png)

^Notes
- SourceKit is the XPC process that does all the code highlighting

---

# SourceKitten

### [github.com/jpsim/SourceKitten](https://github.com/jpsim/SourceKitten)

1. Swift code highlighting
2. Swift interface generation from ObjC headers
3. Generate Swift docs from Swift source
4. Swift code highlighting
5. USR generation

---

# Resources

* jazzy: [github.com/realm/jazzy](https://github.com/realm/jazzy)
* appledoc: [github.com/tomaz/appledoc](https://github.com/tomaz/appledoc)
* swift doc syntax: [nshipster.com/swift-documentation](http://nshipster.com/swift-documentation)
* SourceKit: [jpsim.com/uncovering-sourcekit](http://jpsim.com/uncovering-sourcekit)
* SourceKitten: [github.com/jpsim/SourceKitten](https://github.com/jpsim/SourceKitten)

---

# [fit] `CocoaHeads().questions?.askThem!`

---

# JP Simard, *[@simjp](https://twitter.com/simjp)*, *[realm.io](http://realm.io)*
