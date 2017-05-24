import Foundation
import RealmSwift
import ObjectMapper

infix operator < /* custom operator used for all non transformed objects allows us to pass objects through an object type validator */

func << <Transform: TransformType>(left: inout Transform.Object, right: (ObjectMapper.Map, Transform)) {

    if right.0.mappingType == .toJSON {
        left >>> right
    } else {
        left <- right
    }
}

func << <Transform: TransformType>(left: inout Transform.Object?, right: (ObjectMapper.Map, Transform)) {

    if right.0.mappingType == .toJSON {
        left >>> right
    } else {
        left <- right
    }
}

func << <T>(left: inout T, right: Map) {

    if right.mappingType == .toJSON {
        left >>> right
        return
    }

    if let context = right.context as? Context, let keyValue = right.currentKey, let classType = context.classType {
        left <- (right, validateObjectType(classType, key: keyValue))
    } else {
        print("no class type or property key or map context available during parsing for property")
        left <- right
    }
}

func << <T: PrimitiveObject>(left: inout[T], right: Map) {

    if right.mappingType == .toJSON {
        let valuesArray: [Any]? = valuesFromPrimitiveObjects(Array(left))
        valuesArray >>> right
    }

    if right.mappingType == .fromJSON {

        if let primitiveValues = right.currentValue as? [Any], primitiveValues.isEmpty == false {

            if primitiveValues is [T.ValueType] {
                left = primitiveObjectsFromValues(primitiveValues as? [T.ValueType]) ?? []
            } else if let context = right.context as? Context,
                let keyValue = right.currentKey,
                let classType = context.classType {
                ParsingErrorHandler.handleError(String(describing: classType),
                    expectedType: String(describing: T.ValueType.self),
                    actualType: String(describing: primitiveValues.self),
                    propertyKey: keyValue)
            } else {
                print("no class type or property key or map context available during parsing for property")
            }
        }
    }
}
