# Talk proposals & ideas

## A Brief, Incomplete, and Mostly Wrong History of Databases on iOS

According to the lore, Core Data is just 10 years old, but its genesis dates way back to NeXT's Enterprise Objects of 1994. In this talk, we'll embark on a wild ride exploring the exhilarating and action-packed history of databases on iOS. But seriously, it's just databases, so contain your excitement.

## Cutting Through the Hype

For all the talk about shiny new APIs **XYZ** that'll *change the world*, these remain pretty rarely used. In this talk, we'll go through a few tangible things that might not make headlines, but that will demystify some of the hottest API's around.

iBeacons, Multipeer Connectivity, UIDynamics and others are *cool*, but why would I add them to my app? We'll cover tangible ways to use these technologies in meaningful ways.

## Xcode Internals

* There are next to no modifications to Clang to support Swift.
* SourceKitService sourcekitd is an xpc service.
* libclang lives inside Xcode process. With Swift, libclang lives outside Xcode process.
* SourceKitService runs a compiler and is linked against compiler libraries.
* Xcode can make a request to give an interface for a given header.
* Apple uses python with bindings to sourcekit.
