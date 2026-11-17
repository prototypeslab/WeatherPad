import CoreImage

#if os(iOS)
import UIKit
#endif


infix operator +/ : AdditionPrecedence


infix operator ?= : AssignmentPrecedence


precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence


func ?= <T>(lhs: inout T, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}

func ?= <T>(lhs: inout T?, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}


func + <NumericType: Numeric>(lhs: NumericType, rhs: Bool) -> NumericType {
    return lhs + (rhs ? 1 : 0)
}

func + <NumericType: Numeric>(lhs: Bool, rhs: NumericType) -> NumericType {
    return (lhs ? 1 : 0) + rhs
}

extension CGFloat {

    static var min: CGFloat {  return leastNormalMagnitude }

    static var max: CGFloat { return greatestFiniteMagnitude }

}

extension Dictionary {

    static func + (lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        var dict = lhs
        rhs.forEach { dict[$0.key] = $0.value }
        return dict
    }

    static func += (lhs: inout Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) {
        lhs = lhs + rhs
    }

}

extension NSRange {

    static var zero: NSRange { return NSMakeRange(0, 0) }

    static var invalid: NSRange { return NSMakeRange(0, -1) }

    var max: Int { return NSMaxRange(self) }

    var bridgedRange: Range<Int> { return location ..< max }

    var valid: Bool { return length > -1 }

}

extension NSRange {

    static func + (lhs: NSRange, rhs: (location: Int, length: Int)) -> NSRange {
        return NSMakeRange(lhs.location + rhs.location, lhs.length + rhs.length)
    }

}

extension NSRange {

    mutating func shiftLocation(by offset: Int, keepLength: Bool = false) {
        location += offset
        length = keepLength ? length : Swift.max(length - offset, 0)
    }

    func shiftingLocation(by offset: Int, keepLength: Bool = false) -> NSRange {
        return NSMakeRange(location + offset, keepLength ? length : Swift.max(length - offset, 0))
    }

    mutating func contract(by width: Int) {
        location += width
        length = Swift.max(length - (width * 2), 0)
    }

    mutating func expand(by width: Int) {
        location -= width
        length += (width * 2)
    }

    func contracted(by width: Int) -> NSRange {
        return NSMakeRange(location + width, Swift.max(length - (width * 2), 0))
    }

    func expanded(by width: Int) -> NSRange {
        return NSMakeRange(location - width, length + (width * 2))
    }

}

#if os(iOS)
extension NSShadow {

    var color: UIColor? {
        get { return shadowColor as? UIColor }
        set { shadowColor = newValue }
    }

    var cgColor: CGColor? {
        get { return color?.cgColor }
        set {
            guard let cgColor = newValue else { color = nil; return }
            color = UIColor(cgColor: cgColor)
        }
    }


}
#endif

extension Range where Bound == Int {

    var length: Bound { return upperBound - lowerBound }

    var bridgedRange: NSRange { return NSMakeRange(lowerBound, length) }

}


struct StringFormattingOption: BaseOptionSet {

    typealias This = StringFormattingOption
    typealias RawValue = Int

    static let escaped = This(1 << 0)

    static let stripOuterBraces = This(1 << 1)

    static let stripOuterBrackets = This(1 << 2)

    static let stripOuterParentheses = This(1 << 3)

    static let truncate = This(1 << 4)

    let rawValue: RawValue

    init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

}



 



#if os(iOS)

extension UIImage {

    var width: CGFloat { return size.width }

    var height: CGFloat { return size.height }

    struct CGAttribute: BaseRawRepresentable {

        typealias This = CGAttribute
        typealias RawValue = String

        let rawValue: String

        static let tintColor = This("tintColor")
        static let alpha = This("alpha")
        static let shadow = This("shadow")
        static let cropSize = This("cropSize")

        init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

    }

    func with(attributes: [CGAttribute: Any]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard
            let cgImage = cgImage,
            let context = UIGraphicsGetCurrentContext()
            else { return nil }
        let rect = CGRect(origin: .zero, size: size)
        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        if let shadow = attributes[.shadow] as? NSShadow {
            context.setShadow(offset: shadow.shadowOffset,
                              blur: shadow.shadowBlurRadius,
                              color: (shadow.color ?? UIColor.black.withAlphaComponent(0.2)).cgColor)
        }
        context.draw(cgImage, in: rect)
        context.clip(to: rect, mask: cgImage)
        if let tintColor = attributes[.tintColor] as? UIColor {
            context.setFillColor(tintColor.cgColor)
            context.setBlendMode(.screen)
            context.fill(rect)
        }
        if let alpha = attributes[.alpha] as? CGFloat, alpha < 1.0 {
            context.setFillColor(UIColor.white.cgColor)
            context.setBlendMode(.normal)
            context.setAlpha(1.0 - alpha)
            context.fill(rect)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let cropSize = attributes[.cropSize] as? CGSize {
            return newImage?.scalingAndCropping(to: cropSize)
        }
        return newImage
    }

    func scalingAndCropping(to targetSize: CGSize) -> UIImage? {

        var scaleFactor: CGFloat = 0.0
        var scaledSize = targetSize
        var thumbnailOrigin: CGPoint = .zero

        if (size != targetSize) {

            let widthFactor = targetSize.width / width
            let heightFactor = targetSize.height / height

            scaleFactor = max(widthFactor, heightFactor)

            scaledSize.width = width * scaleFactor
            scaledSize.height = height * scaleFactor

            if (widthFactor > heightFactor) {
                thumbnailOrigin.y = (targetSize.height - scaledSize.height) * 0.5
            } else if (widthFactor < heightFactor) {
                thumbnailOrigin.x = (targetSize.width - scaledSize.width) * 0.5
            }

        }

        UIGraphicsBeginImageContext(targetSize)

        let rect = CGRect(origin: thumbnailOrigin, size: scaledSize)
        draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage

    }

}

#endif

extension URL {

    static func +/ (lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponent(rhs)
    }

    static func +/ (lhs: URL, rhs: String?) -> URL? {
        guard let rhs = rhs else { return nil }
        return lhs.appendingPathComponent(rhs)
    }

}

func +/ (lhs: URL?, rhs: String) -> URL? {
    guard let lhs = lhs else { return nil }
    return lhs.appendingPathComponent(rhs)
}

extension URL {

    var pathComponentsResolvingSymlinksInPath: [String] {
        return resolvingSymlinksInPath().pathComponents
    }

    @available(OSX 10.11, iOS 9.0, *)
    func relativeTo(baseURL: URL) -> URL {
        return URL(fileURLWithPath: resolvingSymlinksInPath().path, relativeTo: baseURL)
    }

}

