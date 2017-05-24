import ObjectMapper
import RealmSwift

// Mark - transformer objects

func transformDoubleToString(_ map: Map) -> ObjectValidator<String, Double> {

    return ObjectValidator(fromJSON: stringFromDouble,
        toJSON: doubleFromString,
        classType: (map.context as? Context)?.classType,
        key: map.currentKey)
}

func transformStringToDouble(_ map: Map) -> ObjectValidator<Double, String> {

    return ObjectValidator(fromJSON: doubleFromString,
        toJSON: stringFromDouble,
        classType: (map.context as? Context)?.classType,
        key: map.currentKey)
}

func transformIntToString(_ map: Map) -> ObjectValidator<String, Int> {

    return ObjectValidator(fromJSON: stringFromInt,
        toJSON: intFromString,
        classType: (map.context as? Context)?.classType,
        key: map.currentKey)
}

func transformStringToInt(_ map: Map) -> ObjectValidator<Int, String> {

    return ObjectValidator(fromJSON: intFromString,
        toJSON: stringFromInt,
        classType: (map.context as? Context)?.classType,
        key: map.currentKey)
}

func transformDictionaryToObjectMappable<T: BaseMappable>(_ map: Map) -> ObjectValidator<T, [AnyHashable: Any]> {

    return ObjectValidator(fromJSON: objectMappableFromDictionary,
        toJSON: dictionaryFromObjectMappable,
        classType: (map.context as? Context)?.classType,
        key: map.currentKey)
}

func transformArrayToObjectArray<T: BaseMappable>(_ map: Map) -> ObjectValidator<[T], [[AnyHashable: Any]]> {

    return ObjectValidator(fromJSON: objectArrayFromObjects,
        toJSON: objectsFromObjectArray,
        classType: (map.context as? Context)?.classType,
        key: map.currentKey)
}

func transformStringToDate(type: DateFormatterType? = nil, _ map: Map) -> ObjectValidator<Date, String> {

    var fromJSON: (String?) -> Date?
    var toJSON: (Date?) -> String?

    let formatter: DateFormatterType

    if type != nil {
        formatter = type!
    } else {
        formatter = .defaultFormatter
    }

    switch formatter {
    case .short:
        fromJSON = shortDateFromString
        toJSON = stringFromShortDate
    case .defaultFormatter:
        fallthrough
    default:
        fromJSON = defaultDateFromString
        toJSON = stringFromDefaultDate
    }

    return ObjectValidator(fromJSON: fromJSON,
        toJSON: toJSON,
        classType: (map.context as? Context)?.classType,
        key: map.currentKey)
}

// MARK: - validation objects

func validateObjectType<T>(_ classType: AnyClass, key: String) -> ObjectValidator<T, T> {

    return ObjectValidator(fromJSON: validateObject,
        toJSON: validateObject,
        classType: classType,
        key: key)
}
