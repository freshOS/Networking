![Networking](https://raw.githubusercontent.com/freshOS/Networking/master/banner.png)

# Networking
[![Language: Swift 5](https://img.shields.io/badge/language-swift5-f48041.svg?style=flat)](https://developer.apple.com/swift)
![Platform: iOS 13+](https://img.shields.io/badge/platform-iOS%2013%2B-blue.svg?style=flat)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/freshOS/ws/blob/master/LICENSE)
[![Build Status](https://app.bitrise.io/app/a6d157138f9ee86d/status.svg?token=W7-x9K5U976xiFrI8XqcJw&branch=master)](https://app.bitrise.io/app/a6d157138f9ee86d)
[![codebeat badge](https://codebeat.co/badges/ae5feb24-529d-49fe-9e28-75dfa9e3c35d)](https://codebeat.co/projects/github-com-freshos-networking-master)
![Release version](https://img.shields.io/github/release/freshOS/Networking.svg)


The simplest JSON Networking layer for Swift.
Because JSON apis are used in **99% of iOS Apps**, this should be  **simple**.

```swift
struct Api: NetworkingService {

    let network = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")

    func fetchPost() -> AnyPublisher<Post, Error> {
        get("/posts/1")
    }
}
```
// Later...
```swift
let api = Api()
api.fetchPost().sink(receiveCompletion: { _ in }) { post in
    // Get back some post \o/
}.store(in: &cancellables)
```

## How
By providing a lightweight client that **automates boilerplate code everyone has to write**.  
By exposing a **delightfully simple** api to get the job done simply, clearly, quickly.  
Getting swift models from a JSON api is now *a problem of the past*

URLSession + Combine + Generics + Protocols = Networking.

## What
- [x] Build concise Apis
- [x] Automatically map your models
- [x] Built-in network logger
- [x] Pure Swift, Simple & Lightweight
- [x] Uses Apple's Combine
- [x] 0 Dependencies

## Welcome the future. Bye ws , Hello Networking.
Networking is the next generation of the [ws](https://github.com/freshOS/ws) project.
The improvements are: Using Combine native Apple's framework over [Then](https://github.com/freshOS/Then) Promise Library, removing [Arrow](https://github.com/freshOS/Arrow) dependency to favour Codable (Arrow can still be adatped easily though) and removing the [Alamofire](https://github.com/Alamofire/Alamofire) dependency in favour of a simpler purely native [URLSession](https://developer.apple.com/documentation/foundation/urlsession) implementation.  
In essence, less dependencies and more native stuff.

## Try it!

Networking is part of [freshOS](https://freshos.github.io) iOS toolset. Try it in an example App ! <a class="github-button" href="https://github.com/freshOS/StarterProject/archive/master.zip" data-icon="octicon-cloud-download" data-style="mega" aria-label="Download freshOS/StarterProject on GitHub">Download Starter Project</a>

## Install it
`Networking` is installed via the official [Swift Package Manager](https://swift.org/package-manager/).  

Select `Xcode`>`File`> `Swift Packages`>`File`>`Add Package Dependency...`  
and add `https://github.com/freshOS/Networking`.

## Create a Networking Client

```swift
let client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
```

## Make your first call
Use `get`, `post`, `put` & `delete` methods on the client to make calls.
```swift
client.get("/posts/1").sink(receiveCompletion: { _ in }) { (data:Data) in
    // data
}.store(in: &cancellables)
```

## Get the type you want back with type infernce
`Networking` recognizes the type you want back.  
Types supported are `Void`, `Data`, `Any`(JSON), `NetworkingJSONDecodable`(Your Model) & `[NetworkingJSONDecodable]`  

This enables keeping a simple api while supporting many types :
```swift
let voidPublisher: AnyPublisher<Void, Error> = client.get("")
let dataPublisher: AnyPublisher<Data, Error> = client.get("")
let jsonPublisher: AnyPublisher<Any, Error> = client.get("")
let postPublisher: AnyPublisher<Post, Error> = client.get("")
let postsPublisher: AnyPublisher<[Post], Error> = client.get("")
```

## Pass params
```swift
client.get("/posts/1", params: ["optin" : true ])
    .sink(receiveCompletion: { _ in }) { (data:Data) in
      //  response
    }.store(in: &cancellables)
```
