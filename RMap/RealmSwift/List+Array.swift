import RealmSwift
import ObjectMapper

/**
 converts between list objects and arrays
 */

extension List where T: PrimitiveObject {

    func toArray() -> [T.ValueType] {
        return Array(self).flatMap { $0.valueItem() }
    }

    func setWithObjectsFromArray(_ array: [T.ValueType]) {
        self.removeAll()
        array.forEach {
            let obj = T()
            obj.setValueItem($0)
            self.append(obj)
        }
    }
}

extension List where T: Object, T: Mappable {

    func toArray() -> [T] {
        return Array(self)
    }

    func setWithObjectsFromArray(_ array: [T]) {
        self.removeAll()
        self.append(objectsIn: array)
    }
}
