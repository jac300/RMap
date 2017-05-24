import ObjectMapper
import RealmSwift

/* parse objects to/from JSON objects or with file name */

extension Mapper {

    func fromJSON(_ dictionary: [String: Any]) -> N? {
        return Mapper<N>().map(JSON: dictionary)
    }

    func fromJSONArray(_ array: [Any]) -> [N?] {
        if let array = Mapper<N>().mapArray(JSONObject: array) {
            return array
        }

        return []
    }
}

func JSONObjectFromString(_ JSONString: String?) -> Any? {

    if let JSONString = JSONString, let data = JSONString.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            print("Error converting JSON string to JSON object: \(error.localizedDescription)")
        }
    }
    return nil
}

func JSONStringFromObject(_ object: Any?) -> String? {

    if let object = object {

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonString
        } catch {
            print("Error converting JSON string to JSON object: \(error.localizedDescription)")
        }
    }

    return nil
}
