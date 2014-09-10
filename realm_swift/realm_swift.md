# [fit] **Realm**

## The First **Swift Optimized** Database

![](media/realm_github.png)

---

# What is Realm?

* **Fast, embedded database** (zero-copy, not an ORM)
* **Used in apps with *millions* of users**
* **NoSQL**
* **Full [ACID](http://en.wikipedia.org/wiki/ACID) transactions**
* **Well defined threading model**
* **Cross-platform C++ core with many language bindings** (only Objective-C & Swift released)

^Notes
- Atomicity, Consistency, Isolation, Durability
- Most NoSQL stores lack true ACID transactions
- Same file format across platforms

---

# Open Source*

# [fit] ![](media/octocat.png)

## [github.com/realm/*realm-cocoa*](https://github.com/realm/realm-cocoa)

### \* Bindings 100% open source, C++ core being released as Apache 2

---

# Core Data in Swift

Core Data goes against Swift's strong type safety and generics features.

```swift
let myPersonClass: AnyClass = 
  NSClassFromString("MyGreatApp.Person")
```

---

# Apple had to invent special language constructs in Swift to support Core Data!!

---

> Like the `@dynamic` attribute in Objective-C, the `@NSManaged` attribute informs the Swift compiler that the storage & implementation of a property will be provided at runtime.

^Notes
- https://developer.apple.com/library/prerelease/mac/documentation/Swift/Conceptual/BuildingCocoaApps/WritingSwiftClassesWithObjective-CBehavior.html

---

# Managed context in Core Data

```swift
@lazy var managedObjectContext: NSManagedObjectContext = {
  let modelURL = NSBundle.mainBundle().URLForResource("SwiftTestOne", withExtension: "momd")
  let mom = NSManagedObjectModel(contentsOfURL: modelURL)
  ZAssert(mom != nil, "Error initializing mom from: \(modelURL)")

  let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

  let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
  let storeURL = (urls[urls.endIndex-1]).URLByAppendingPathComponent("SwiftTestOne.sqlite")

  var error: NSError? = nil

  var store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
  if (store == nil) {
    println("Failed to load store")
  }
  ZAssert(store != nil, "Unresolved error \(error?.localizedDescription), \(error?.userInfo)\nAttempted to create store at \(storeURL)")

  var managedObjectContext = NSManagedObjectContext()
  managedObjectContext.persistentStoreCoordinator = psc

  return managedObjectContext
}()
```

^Notes
- http://www.cimgf.com/2014/06/08/the-core-data-stack-in-swift

---

# Realm in Swift

* **Generics**
* **Type Safety**
* **Default Values**
* **Swift Objects**
* **No Code Generation**
* **Zero Copy**

---

# Realm Models

```swift
class Employee: Object {
  dynamic var name = "" // you can specify defaults
  dynamic var startDate = NSDate()
  dynamic var salary = 0.0
  dynamic var fullTime = true
}

class Company: Object {
  dynamic var name = ""
  dynamic var ceo = Employee()
  dynamic var employees = ArrayProperty(Employee)
}
```

^Notes
- This is all you have to do to define your models
- No code generation, keeping graphical/code in sync
- dynamic backs objects & properties directly by database

---

# Using Realm

```swift
// Using Realm Objects
let company = Company()
company.name = "Realm" // etc...

// Transactions
defaultRealm().transaction() {
  realm.add(company)
}

// Querying objects
let companies = objects(Company)
companies[0]?.name // => Realm (generics)
let ftEmployees = objects(Employee).filter(.fullTime == true || .name == "John")
```

---

# Work In Progress

* Change notifications/Live Results Sets
* Primary Keys/Upsert/JSON Mapping
* Delete Rules 
* Bi-directional relationships
* Sync
* Open Source Core
* Android

---

# Resources

* [Realm on GitHub](https://github.com/realm/realm-cocoa) **(github.com)**
* [Realm's WIP Swift branch](https://github.com/realm/realm-cocoa/tree/jp-swift-syntax-beta7) **(github.com)**
* [Writing Swift Classes With Objective-C Behavior](https://developer.apple.com/library/prerelease/mac/documentation/Swift/Conceptual/BuildingCocoaApps/WritingSwiftClassesWithObjective-CBehavior.html) **(apple.com)**
* [The Core Data Stack in Swift](http://www.cimgf.com/2014/06/08/the-core-data-stack-in-swift) **(cimgf.com)**

---

# [fit] Questions?

## @simjp, jp@realm.io
