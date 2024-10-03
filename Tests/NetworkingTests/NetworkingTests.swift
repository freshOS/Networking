import Testing
import Networking
import Combine

struct NetworkingTests {

    @Test
    func badURLDoesntCrash() async {
        let client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
        do {
            let _: JSON = try await client.get("/forge a bad url")
        } catch {
            if let e = error as? NetworkingError, e.status == .unableToParseRequest {
                print("OK")
            } else {
                print("OK2")
            }
        }        
    }
}
