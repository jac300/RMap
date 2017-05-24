import ObjectMapper

// MARK: - string <-> double

func doubleFromString(_ value: Any?) -> Double? {
    guard let value = value as? String else {
        print("error transforming string to double, unexpected value type")
        return nil
    }
    guard !value.isEmpty else { return 0 }
    guard let doubleValue = Double(value) else {
        print("error transforming string to double \(value)")
        return nil
    }
    return doubleValue
}

func stringFromDouble(_ value: Any?) -> String? {
    guard let value = value else { return nil }
    guard let doubleVal = value as? Double else {
        print("error transforming double to string, unexpected value type")
        return nil
    }

    return String(doubleVal)
}

// MARK: - string <-> int

func intFromString(_ value: Any?) -> Int? {
    guard let value = value else { return nil }
    guard let strVal = value as? String else {
        print("error transforming string to int, unexpected value type")
        return nil
    }
    guard !strVal.isEmpty else { return 0 }
    guard let intValue = Int(strVal) else {
        print("error transforming string to int \(strVal)")
        return nil
    }
    return intValue
}

func stringFromInt(_ value: Any?) -> String? {
    guard let value = value else { return nil }
    guard let intVal = value as? Int else {
        print("error transforming int to string, unexpected value type")
        return nil
    }

    return String(intVal)
}

// MARK: - string  <-> date

func dateFromString(_ value: Any?, _ formatter: DateFormatterType) -> Date? {
    guard let value = value as? String else { return nil }
    return formatterForType(formatter, fromJSON: true).date(from: value)
}

func stringFromDate(_ value: Any?, _ formatter: DateFormatterType) -> String? {
    guard let value = value as? Date else { return nil }
    return formatterForType(formatter, fromJSON: false).string(from: value)
}

func defaultDateFromString(_ value: Any?) -> Date? {
    return dateFromString(value, .defaultFormatter)
}

func stringFromDefaultDate(_ value: Any?) -> String? {
    return stringFromDate(value, .defaultFormatter)
}

func shortDateFromString(_ value: Any?) -> Date? {
    return dateFromString(value, .short)
}

func stringFromShortDate(_ value: Any?) -> String? {
    return stringFromDate(value, .short)
}

// MARK: - dictionary <-> realm object

func objectMappableFromDictionary<T: BaseMappable>(_ value: Any?) -> T? {
    guard let value = value as? [String: Any] else { return nil }
    return Mapper<T>().map(JSON: value)
}

func dictionaryFromObjectMappable<T: BaseMappable>(_ value: T?) -> [AnyHashable: Any]? {
    guard let value = value else { return nil }
    return (value).toJSON()
}

// MARK: - primitive realm object arrays

func primitiveObjectsFromValues<T: PrimitiveObject>(_ value: [T.ValueType]?) -> [T]? {
    guard let value = value else { return nil }
    var array = [T]()
    value.forEach {
        var obj: T
        obj = T()
        obj.setValueItem($0)
        array.append(obj)
    }

    return array
}

func valuesFromPrimitiveObjects<T: PrimitiveObject>(_ value: [T]?) -> [T.ValueType]? {
    guard let value = value else { return nil }
    return value.flatMap { $0.valueItem() }
}

// MARK: - realm object arrays

func objectArrayFromObjects<T: BaseMappable>(_ value: Any?) -> [T]? {
    guard let value = value else { return nil }
    return Mapper<T>().mapArray(JSONObject: value)
}

func objectsFromObjectArray<T: BaseMappable>(_ value: [T]?) -> [[AnyHashable: Any]] {
    guard let value = value else { return [] }
    return (value).toJSON()
}

// MARK: - validator func - validates received object type

func validateObject<T>(_ value: Any?) -> T? {
    guard let value = value else { return nil }
    return value as? T
}

// MARK: - date helpers

enum DateFormatterType: Int {
    case defaultFormatter = 0, short
}

func formatterForType(_ formatter: DateFormatterType, fromJSON: Bool) -> DateFormatter {

    switch formatter {
    case .short:
        return DateFormats.shortFormatter
    case .defaultFormatter:
        fallthrough
    default:
        return DateFormats.longFormatter
    }
}
