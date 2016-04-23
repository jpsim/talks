slidenumbers: true

<!-- Background patterns from http://qrohlf.com/trianglify-generator -->
<!-- Other images from unsplash.com -->

# [fit] SourceKit
# [fit] *and* **You**

### JP Simard – [@simjp](https://twitter.com/simjp) – [App Builders](http://appbuilders.ch) – Zürich – April 25, 2016

![](bg1.png)

^
Abstract: SourceKit is more than crashes. In this talk, I'll show you how it's a powerful tool that you can use to gain insight into your codebase, even manipulate to do codegen, refactoring, formatting, etc.

---

# [fit] SourceKit *and* **Me**
<!-- Non-Breaking Space -->
###  
# *JP Simard ( 🇨🇦 ➡︎ 🇺🇸)*
<!-- Non-Breaking Space -->
###  
# ObjC/Swift @ Realm

![](bg2.png)

---

![original](realm.png)

---

# [fit] SourceKit *and* **Me**
<!-- Non-Breaking Space -->
###  
# [fit] *Product Needed API Docs & Clean Code*
<!-- Non-Breaking Space -->
###  
# [fit] SourceKit *was the key*

![](bg1.png)

---

# [fit] The SourceKit
# [fit] *You* **Know**

* More than *just* crashes & HUDs
* Very powerful tool

<!-- To Do: use hotkey -->
![](bg2.png)

^
SourceKit is more than just crashes & HUDs, despite that being the only time you probably think about it.
It's actually a very powerful tool

---

# [fit] The SourceKit
# [fit] *You* **See**

![](bg1.png)

---

# [fit] The SourceKit *You* **See**

* Syntax Highlighting
* Code Completion
* Indentation
* Interface Generation
* Documentation Rendering
* Code Structure
* USR Generation

![](bg2.png)

---

# [fit] ![13%](octocat.png)<sup>*[apple/swift/tools/SourceKit](https://github.com/apple/swift/tree/master/tools/SourceKit)*</sup>
<!-- Non-Breaking Space -->
 
SourceKit is a framework for supporting IDE features like indexing, syntax-coloring, code-completion, etc.

In general it provides the infrastructure that an IDE needs for excellent language support. *– Apple*

![](bg1.png)

---

# [fit] The SourceKit
# [fit] *You*
# [fit] **Don't See**

![](bg2.png)

---

# [fit] The SourceKit *You* **Don't See**

* Components
  * libIDE
  * libParse
  * libFormat
  * libXPC *(Darwin-Only)*
  * libdispatch *(Darwin-Only)*
* C++ Implementation

![](bg1.png)

^
Darwin only for now because of the dependencies on libXPC & libdispatch, now with swift-corelibs-dispatch should be possible to port to Linux.

---

# [fit] The SourceKit
# [fit] *You*
# [fit] **Interface With**

![](bg2.png)

---

# [fit] The SourceKit *You* **Interface With**

* C Interface
* `sourcekitd.framework`
* `libsourcekitdInProc.dylib`
* Official Python Binding
* Unofficial Swift Binding: SourceKitten

![](bg1.png)

---

# [fit] ![13%](octocat.png)<sup>*[apple/swift/tools/SourceKit](https://github.com/apple/swift/tree/master/tools/SourceKit)*</sup>
<!-- Non-Breaking Space -->
 
The stable C API for SourceKit is provided via the `sourcekitd.framework` which uses an XPC service for process isolation and the `libsourcekitdInProc.dylib` library which is in-process. *– Apple*

![](bg2.png)

---

# [fit] SourceKitten
<!-- Non-Breaking Space -->
 
An *adorable* little framework and command line tool for interacting with SourceKit.

# ![13%](octocat.png)<sup>*[github.com/jpsim/SourceKitten](https://github.com/github.com/jpsim/SourceKitten)*</sup>

![](https://images.unsplash.com/photo-1445499348736-29b6cdfc03b9)

---

```
$ brew install sourcekitten
...
$ sourcekitten version
0.12.2
$ sourcekitten help
Available commands:

   complete    Generate code completion options
   doc         Print Swift docs as JSON or Objective-C docs as XML
   help        Display general or command-specific help
   index       Index Swift file and print as JSON
   structure   Print Swift structure information as JSON
   syntax      Print Swift syntax information as JSON
   version     Display the current version of SourceKitten
```

![](bg1.png)

---

# [fit] The SourceKit
# [fit] *You* **Build On**

![](bg2.png)

---

# [fit] The SourceKit *You* **Build On**

* Code Analysis
* Refactoring
* Migration
* Code Generation

![](bg1.png)

^
Let's go through a few examples of using SourceKit to accomplish some tasks similar to ones you might want to perform on your own codebase

---

# [fit] Code
# [fit] **Analysis**

^
Say you have a large codebase and you're interested in analyzing trends over time...
- average lengths of functions
- size of your public API
- distribution of types in your codebase (e.g. structs, classes, enums, protocols)

![](bg2.png)

---

<sub>`$ cat PublicDeclarations.swift`</sub>

```swift
public struct A {
  public func b() {}
  private func c() {}
}
```
```bash
$ echo $query
  [recurse(.["key.substructure"][]?) |
    select(."key.accessibility" == "source.lang.swift.accessibility.public") |
    ."key.name"?]

$ sourcekitten structure --file PublicDeclarations.swift | jq $query
  ["A", "b()"]
```

![](bg1.png)

^
sourcekitten structure --file 1.swift | jq "`cat 1.jq`"

---

<sub>`$ cat FunctionsPerStruct.swift`</sub>

```swift
struct A { func one() {} }
struct B { let nope = 0; func two() {}; func three() {} }
```
```bash
$ echo $query
  [."key.substructure"[] | select(."key.kind" == "source.lang.swift.decl.struct") |
    {key: ."key.name", value: [
      (."key.substructure"[] |
        select(."key.kind" == "source.lang.swift.decl.function.method.instance") |
        ."key.name")]}
  ] | from_entries

$ sourcekitten structure --file FunctionsPerStruct.swift | jq $query
  {"A": ["one()"], "B": ["two()", "three()"]}
```

![](bg2.png)

^
sourcekitten structure --file 2.swift | jq "`cat 2.jq`"

---

<sub>`$ cat LongFunctionNames.swift`</sub>

```swift
func okThisFunctionMightHaveAnOverlyLongNameThatYouMightWantToRefactor() {}
func nahThisOnesFine() {
  func youCanEvenFindNestedOnesIfYouRecurse() {}
}
```
```bash
$ echo $query
  [recurse(.["key.substructure"][]?) |
      select(."key.kind" | tostring | startswith("source.lang.swift.decl.function")) |
      select((."key.name" | length) > 20) |
      ."key.name"]

$ sourcekitten structure --file LongFunctionNames.swift | jq $query
  [
    "okThisFunctionMightHaveAnOverlyLongNameThatYouMightWantToRefactor()",
    "youCanEvenFindNestedOnesIfYouRecurse()"
  ]
```

![](bg1.png)

^
sourcekitten structure --file 3.swift | jq "`cat 3.jq`"

---

# [fit] Code
# [fit] **Refactoring**

<sub>In ~30 lines of Swift...</sub>

![](bg2.png)

---

Refactoring (`refactor.swift` 1/2)

```swift
import SourceKittenFramework

let arguments = Process.arguments
let (file, usr, oldName, newName) = (arguments[1], arguments[2], arguments[3], arguments[4])
let index = (Request.Index(file: file).send()["key.entities"] as! [SourceKitRepresentable])
              .map({ $0 as! [String: SourceKitRepresentable] })

func usesOfUSR(usr: String, dictionary: [String: SourceKitRepresentable]) -> [(line: Int, column: Int)] {
    if dictionary["key.usr"] as? String == usr,
        let line = dictionary["key.line"] as? Int64,
        let column = dictionary["key.column"] as? Int64 {
        return [(Int(line - 1), Int(column))]
    }
    return (dictionary["key.entities"] as? [SourceKitRepresentable])?
        .map({ $0 as! [String: SourceKitRepresentable] })
        .flatMap { usesOfUSR(usr, dictionary: $0) } ?? []
}
```

![](bg1.png)

---

Refactoring (`refactor.swift` 2/2)

```swift
func renameUSR(usr: String, toName: String) {
    let uses = index.flatMap({ usesOfUSR(usr, dictionary: $0) }).sort(>)
    let fileContents = try! String(contentsOfFile: file)
    var lines = (fileContents as NSString).lines().map({ $0.content })
    for use in uses {
        lines[use.line] = lines[use.line]
          .stringByReplacingOccurrencesOfString(oldName, withString: newName)
    }
    print(lines.joinWithSeparator("\n"))
}

renameUSR(usr, toName: newName)
```

![](bg2.png)

---

<sub>`$ cat CodeToRefactor.swift`</sub>

```swift
struct A { let prop = 0 }
struct B { let prop = 1 }
print(A().prop)
print(B().prop)
```

<sub>`$ ./refactor.swift CodeToRefactor.swift s:vV4file1A4propSi prop newProp`</sub>

```swift
struct A { let newProp = 0 }
struct B { let prop = 1 }
print(A().newProp)
print(B().prop)
```

![](bg1.png)

^
sourcekitten index --file 4.swift | jq

---

# [fit] Code
# [fit] **Migration**

<sub>Same principle as refactoring...</sub>

![](bg2.png)

^
Xcode includes a tool to help migrate to newer Swift versions, but what if you need to update a non-Apple framework your app uses which introduces lots of API changes?

---

# [fit] Code
# [fit] **Generation**

![](bg1.png)

---

<sub>`$ cat GenerateXCTestManifest.swift`</sub>

```swift
class MyTests: XCTestCase { func nope() {}; func testYolo() {} }
```
```bash
$ echo $query
  [."key.substructure"[] |
    select(."key.kind" == "source.lang.swift.decl.class") |
    select(."key.inheritedtypes"[]."key.name" == "XCTestCase") |
    {key: ."key.name", value: [
      (."key.substructure"[] |
        select(."key.kind" == "source.lang.swift.decl.function.method.instance") |
        select(."key.name" | startswith("test")) |
        ."key.name")]}
  ] | from_entries

$ sourcekitten structure --file GenerateXCTestManifest.swift | jq $query
  {"MyTests": ["testYolo()"]}
```

![](bg2.png)

^
From here, it's easy to generate `main.swift` for use with XCTest on Linux.
Or you can easily build your own test runner using different syntaxes, like something rspec-like.
sourcekitten structure --file 5.swift | jq "`cat 5.jq`"

---

QueryKit Model Generation (`generate.swift` 1/2)

```swift
import SourceKittenFramework
struct Property {
    let name: String
    let type: String
    var swiftSourceRepresentation: String {
        return "static let \(name) = Property<\(type)>(name: \"\(name)\")"
    }
}
struct Model {
    let name: String
    let properties: [Property]
    var swiftSourceRepresentation: String {
        return "extension \(name) {\n" +
            properties.map({"  \($0.swiftSourceRepresentation)"}).joinWithSeparator("\n") +
            "\n}"
    }
}
```

![](bg1.png)

---

QueryKit Model Generation (`generate.swift` 2/2)

```swift
let structure = Structure(file: File(path: Process.arguments[1])!)
let models = (structure.dictionary["key.substructure"] as! [SourceKitRepresentable]).map({
    $0 as! [String: SourceKitRepresentable]
}).filter({ substructure in
    return SwiftDeclarationKind(rawValue: substructure["key.kind"] as! String) == .Struct
}).map { modelStructure in
    return Model(name: modelStructure["key.name"] as! String,
        properties: (modelStructure["key.substructure"] as! [SourceKitRepresentable]).map({
            $0 as! [String: SourceKitRepresentable]
        }).filter({ substructure in
            return SwiftDeclarationKind(rawValue: substructure["key.kind"] as! String) == .VarInstance
        }).map { Property(name: $0["key.name"] as! String, type: $0["key.typename"] as! String) }
    )
}

print(models.map({ $0.swiftSourceRepresentation }).joinWithSeparator("\n"))
```

![](bg2.png)

---

<sub>`$ cat QueryKitModels.swift`</sub>

```swift
struct Person {
  let name: String
  let age: Int
}
```

<sub>`$ ./generate.swift QueryKitModels.swift`</sub>

```swift
extension Person {
  static let name = Property<String>(name: "name")
  static let age = Property<Int>(name: "age")
}
```

![](bg1.png)

^
sourcekitten structure --file 6.swift | jq

---

# [fit] The SourceKit
# [fit] *I Didn't Have Time To Cover*
# [fit] **In This Talk**

![](bg2.png)

---

## The SourceKit *I Didn't Have Time To Cover* **In This Talk**

* Code Formatting
* Code Completion
* Syntax Highlighting
* Documentation Generation
* More IDE-like Features

![](bg1.png)

---

# [fit] The SourceKit
# [fit] *Others*
# [fit] **Have Built On**

![](bg2.png)

---

# [fit] The SourceKit *Others* **Have Built On**

* **[Jazzy<sup>♪♫</sup>](https://github.com/realm/jazzy)**: Soulful docs for Swift & Objective-C
* **[SwiftLint](https://github.com/realm/SwiftLint)**: A tool to enforce Swift style and conventions
* **[Refactorator](https://github.com/johnno1962/Refactorator)**: Xcode Plugin that Refactors Swift & Objective-C
* **[SourceKittenDaemon](https://github.com/terhechte/SourceKittenDaemon)**: Swift auto completion for any text editor
* **[SwiftKitten](https://github.com/johncsnyder/SwiftKitten)**: Swift autocompleter for Sublime Text
* **[sourcekittendaemon.vim](https://github.com/keith/sourcekittendaemon.vim)**: Autocomplete Swift in Vim
* **[company-sourcekit](https://github.com/nathankot/company-sourcekit)**: Emacs company-mode completion for Swift projects

![](bg1.png)

^
Other tools that I don't have space to include in the slide, two slides for this seems excessive.
https://github.com/ypresto/SwiftLintXcode
https://github.com/AtomLinter/linter-swiftlint
https://github.com/tokorom/syntastic-swiftlint.vim
https://github.com/mohamede1945/SwiftLintPlugin
https://github.com/Backelite/sonar-swift
https://github.com/google/arc-jazzy-linter
https://github.com/JPMartha/Pancake

---

# *Next time you need to push Swift further...*
<!-- Non-Breaking Space -->
###  
# [fit] Try **SourceKit**

![](bg2.png)

---

# [fit] **Thanks!**
<!-- Non-Breaking Space -->
###  
### JP Simard – [@simjp](https://twitter.com/simjp) – [App Builders](http://appbuilders.ch) – Zürich – April 25, 2016

![](bg1.png)
