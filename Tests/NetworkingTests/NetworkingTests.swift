import XCTest
import Networking
import Combine

final class NetworkingTests: XCTestCase {
    
    var cancellable: Cancellable?
    
    func testUsagesGet() {
        let exp1 = expectation(description: "call")
        let exp2 = expectation(description: "call")
        let exp3 = expectation(description: "call")
        let exp4 = expectation(description: "call")
        let exp5 = expectation(description: "call")
        let exp6 = expectation(description: "call")
    
        // Create client.
        let client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
        
        // Data
        client.get("/posts/1").then { data in
            exp1.fulfill()
        }
        
        // JSON
        client.get("/posts/1").toJSON().then { json in
            exp2.fulfill()
        }
        
        // Model explicit
        client.get("/posts/1").toModel(Post.self).then { model in
            exp3.fulfill()
        }
        
        // Model implicit
        client.get("/posts/1").toModel().then { (model: Post) in
            exp4.fulfill()
        }
        
        // JSON (auto generic)
        client.get("/posts/1").then { (json:Any) in
            exp5.fulfill()
        }
        
        // Model (auto generic)
        client.get("/posts/1").then { (todo: Post) in
            exp6.fulfill()
        }
    
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testApiStyleGet() {
        let exp = expectation(description: "call")
        let api: Api = ConcreteJSONApi()
        
        cancellable =  api.fetchPost().sink(receiveCompletion: { c in
            
        }, receiveValue: { todo in
            print(todo)
            exp.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testGetModels() {
        let exp = expectation(description: "call")
        let api: Api = ConcreteJSONApi()
        
        api.fetchPosts().then { posts in
            print(posts)
            exp.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    static var allTests = [
        ("testUsagesGet", testUsagesGet),
        ("testApiStyleGet", testApiStyleGet),
        ("testGetModels", testGetModels),
    ]
}



extension Post: Codable {}


// Clean Model
struct Post {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
//{
//  "userId": 1,
//  "id": 1,
//  "title": "delectus aut autem",
//  "completed": false
//}


// Networking Requirements.
// - No dependencies: Generics, Codable, Combine: Pure Native.
// - Leaves Models clean. ( Codable confromance can be made via an extension)
// - Simple to write.
// - Returns Publisher to be used with combine.
// - Favours composition, which is the essence of Combine's philosophy

// TODO - put patch delete
// params.
// Logging
// not ! = send errors.
// Set header


// Force explicit error handling SPECIFYING THE ERROR


protocol Api {
    func fetchPost() -> AnyPublisher<Post, Error>
    func fetchPosts() -> AnyPublisher<[Post], Error>
}

struct ConcreteJSONApi: Api {
    
    let client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
    
    func fetchPost() -> AnyPublisher<Post, Error> {
        return client.get("/posts/1")
    }
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        return client.get("/posts").toModels()
    }
    
}
