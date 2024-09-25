import Testing
import Networking

@Suite
struct ParamsTests {

    @Test
    func asPercentEncodedString() {
        // Simple key value encoding
        #expect("key=value" == ["key": "value"].asPercentEncodedString())
        
        // Array-based key value encoding
        #expect("key[]=value1&key[]=value2" == ["key": ["value1", "value2"]].asPercentEncodedString())
        
        // Dictionary-based key value encoding
        #expect("key[subkey1]=value1" == ["key": ["subkey1": "value1"]].asPercentEncodedString())
    }
}
