Yay, you've ported your Swift code to Linux!
You got all your code & its forest of dependencies _just right_.
Until you realize...
Wait this is slower than macOS!
How is this possible? I thought Linux was web scale!
Could be due to different code implementations, different optimizations, lack of ObjC runtime, different base OS.
How do you solve this? On macOS you'd spin up Instruments.app.
There *is* no `apt-get install instruments.app`
So what _can_ you use?
Tool comparison: callgrind, perf
Platform comparison: VMs, containers, bare metal
Visualization: dot graph, KCachegrind, FlameGraph

On macOS, Intruments.app profilers are implemented using DTrace, which is not available on Linux.
It's technically possible to massage the data you get out of these profilers into something that Instruments.app can read, but I haven't played around with that enough to offer you step-by-step instructions. Good opportunity for someone to write a tool for this.
Callgrind is extremely slow
Running a profiler in a VM or container is kind of like measuring your app's performance compiled in Debug mode. It won't be anywhere close to accurate, but might get you an idea if you're completely lost.
Never trust performance numbers when compiling in Debug mode
