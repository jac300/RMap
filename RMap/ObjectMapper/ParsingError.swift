
class ParsingErrorHandler {

    static func handleError(_ classType: String, expectedType: String, actualType: String, propertyKey: String) {
        let errorString = "unexpected JSON type \(actualType) for expected type: \(expectedType) for object property: \(propertyKey) on class:\(classType)"
        print(errorString)
    }
}
