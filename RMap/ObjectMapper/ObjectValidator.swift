import ObjectMapper
import RealmSwift

/**
 Custom transformer base class (subclassed from ObjectMapper's TransformType) which allows us to catch unexpected types.
 Objects of an unexpected types are logged and returned as nil.
 */

class ObjectValidator<ObjectType, JSONType>: TransformType {

    private var fromJSON: (JSONType?) -> ObjectType?
    private var toJSON: (ObjectType?) -> JSONType?

    private var classType: Any?
    private var key: String?

    init(
        fromJSON: @escaping(JSONType?) -> ObjectType?,
        toJSON: @escaping(ObjectType?) -> JSONType?,
        classType: AnyClass?,
        key: String?) {

        self.fromJSON = fromJSON
        self.toJSON = toJSON
        self.classType = classType
        self.key = key
    }

    func transformFromJSON(_ value: Any?) -> ObjectType? {

        /* if we have a non-nil value whose type does not match the expected JSON type, handle this error */
        if let value = value, value is JSONType == false, let key = key, let classType = classType {
            ParsingErrorHandler.handleError(String(describing: classType),
                expectedType: String(describing: JSONType.self),
                actualType: String(describing: type(of: value).self),
                propertyKey: key)
        }

        return fromJSON(value as? JSONType)
    }

    func transformToJSON(_ value: ObjectType?) -> JSONType? {
        return toJSON(value)
    }
}
