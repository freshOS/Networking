import XCTest
import Networking

final class ParamsTests: XCTestCase {

    func testAsPercentEncodedString() {
        // Simple key value encoding
        XCTAssertEqual("key=value", ["key": "value"].asPercentEncodedString())
        
        // Array-based key value encoding
        XCTAssertEqual("key[]=value1&key[]=value2", ["key": ["value1", "value2"]].asPercentEncodedString())
        
        // Dictionary-based key value encoding
        XCTAssertEqual("key[subkey1]=value1", ["key": ["subkey1": "value1"]].asPercentEncodedString())
    }
}
