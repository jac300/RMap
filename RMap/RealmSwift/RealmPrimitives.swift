import ObjectMapper
import RealmSwift

/**

 Realm swift REQUIRES the use of List objects for arrays. List objects behave like mutable arrays.

 Some unfortunate limitations of List objects are:

 1. They are not recognized by ObjectiveC.
 2. They are REQUIRED to be LET properties.
 3. They are REQUIRED to contain objects that inherit from Object.

 For example, a property of type List<String> is invalid. To work around this, we must wrap
 primitive objects in the primitive object classes below. List<StringObject>, for example, is valid.

 https://github.com/realm/realm-cocoa/issues/1120

 */

// TODO: collapse separate object types into one using generics
protocol PrimitiveObject {

    func setValueItem(_ value: Any)
    func valueItem() -> ValueType?
    associatedtype ValueType
    init()
}

class StringObject: Object, PrimitiveObject {

    dynamic var value: String?
    typealias ValueType = String

    func setValueItem(_ value: Any) {
        self.value = value as? String
    }

    func valueItem() -> ValueType? {
        return value
    }

    required convenience init?(map: Map) {
        self.init()
    }
}

class NumberObject: Object, PrimitiveObject {

    dynamic var value: String?
    typealias ValueType = NSNumber

    func setValueItem(_ value: Any) {
        if let value = value as? NSNumber {
            self.value = String(Double(value))
        }
    }

    func valueItem() -> ValueType? {
        guard let value = value, let double: Double = Double(value) else { return nil }
        return NSNumber(value: double)
    }

    required convenience init?(map: Map) {
        self.init()
    }
}

/**
 Realm Swift does not support AnyObject (undefined) types. AnyObjectObject and functions below are
 used to assist in the parsing & persisting of undefined types.
 */

class AnyObjectObject: Object, PrimitiveObject {

    dynamic var value: String?
    typealias ValueType = Any

    dynamic var isString: Bool = false
    dynamic var isNumber: Bool = false
    dynamic var isCollection: Bool = false

    func setValueItem(_ value: Any) {

        if value is String {
            self.value = value as? String
            isString = true
        } else if value is [AnyHashable: Any] || value is [Any] {
            self.value = JSONStringFromObject(value)
            isCollection = true
        } else if let value = value as? NSNumber {
            self.value = String(Double(value))
            isNumber = true
        }
    }

    func valueItem() -> ValueType? {

        if isString {
            return value
        } else if isNumber {
            guard let value = value, let double: Double = Double(value) else { return nil }
            return NSNumber(value: double)
        } else if isCollection {
            return JSONObjectFromString(value)
        }

        return nil
    }
}

class DictionaryObject: Object, PrimitiveObject {

    dynamic var value: String?
    typealias ValueType = [AnyHashable: Any]

    func setValueItem(_ value: Any) {
        self.value = JSONStringFromObject(value)
    }

    func valueItem() -> ValueType? {
        return JSONObjectFromString(value) as? ValueType
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func toDict() -> [AnyHashable: Any]? {
        return self.valueItem()
    }
}
