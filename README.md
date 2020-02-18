# PerformanceTestTools

Benchmarking for standard callback techniques in Cocoa:

* [Delegate, NotificationCenter, and KVO](https://nalexn.github.io/callbacks-part-1-delegation-notificationcenter-kvo/?utm_source=nalexn_github)
* [Closure, Target-Action, and Responder chain](https://nalexn.github.io/callbacks-part-2-closure-target-action-responder-chain/?utm_source=nalexn_github)

| Technique | Objective-C | Swift |
|:---:|---|---|
| Delegate | 46ns | 81ns |
| NotificationCenter | 1470ns | 2002ns |
| Closure | 120ns | 49ns |
| Invocation | 238ns | - |
| Responder | 1489ns | 1417ns |
| KVO | 1016ns | 7572ns |
| NSOperation | 23461ns | 24838ns |