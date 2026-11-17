
import Foundation

struct Configurations {

    
   static func getValue(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as?
                String else {
            
            return ""
        }
        return value
    }
}


