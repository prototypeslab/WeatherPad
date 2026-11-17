import Foundation


extension Dictionary {

    subscript <RawRepresentableType: RawRepresentable>(key: RawRepresentableType) -> Value?
        where RawRepresentableType.RawValue == Key {
        get { return self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }

}


func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType, rhs: RawRepresentableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs == rhs.rawValue
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType, rhs: RawRepresentableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs != rhs.rawValue
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType, rhs: EquatableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs.rawValue == rhs
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType, rhs: EquatableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs.rawValue != rhs
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType?, rhs: RawRepresentableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs == rhs.rawValue
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType?, rhs: RawRepresentableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs != rhs.rawValue
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType?, rhs: EquatableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs?.rawValue == rhs
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType?, rhs: EquatableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs?.rawValue != rhs
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType, rhs: RawRepresentableType?) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs == rhs?.rawValue
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType, rhs: RawRepresentableType?) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs != rhs?.rawValue
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType, rhs: EquatableType?) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs.rawValue == rhs
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType, rhs: EquatableType?) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs.rawValue != rhs
}


protocol BaseRawRepresentable: Hashable, RawRepresentable where RawValue: Hashable {

    init(_ rawValue: RawValue)

    init(rawValue: RawValue)

}

extension BaseRawRepresentable {

    public var hashValue: Int { return rawValue.hashValue }

    init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }

    func equals(_ values: Self...) -> Bool {
        return values.contains(self)
    }

}


protocol DefaultBaseRawRepresentable: BaseRawRepresentable {

    static var defaultRawValue: RawValue { get }

    static var `default`: Self { get }

    init(_ rawValue: RawValue?)

    init(rawValue: RawValue?)

}

extension DefaultBaseRawRepresentable {

    static var `default`: Self { return Self(Self.defaultRawValue) }

    init(_ rawValue: RawValue?) {
        self.init(rawValue: rawValue ?? Self.defaultRawValue)
    }

    init(rawValue: RawValue?) {
        self.init(rawValue: rawValue ?? Self.defaultRawValue)
    }

}


protocol BaseOptionSet: BaseRawRepresentable, OptionSet {

}

extension BaseOptionSet {

    init?(_ rawValue: RawValue?) {
        guard let rawValue = rawValue else { return nil }
        self.init(rawValue: rawValue)
    }

    init?(rawValue: RawValue?) {
        guard let rawValue = rawValue else { return nil }
        self.init(rawValue: rawValue)
    }

}
