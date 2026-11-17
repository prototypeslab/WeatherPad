#if canImport(UIKit)
import UIKit
public typealias SFFont = UIFont


extension UIFont {

    public enum OpenSansType: String {
        case extraboldItalic = "-ExtraboldItalic"
        case semiboldItalic = "-SemiboldItalic"
        case semibold = "-Semibold"
        case regular = ""
        case lightItalic = "Light-Italic"
        case light = "-Light"
        case italic = "-Italic"
        case extraBold = "-Extrabold"
        case boldItalic = "-BoldItalic"
        case bold = "-Bold"
    }

    static func OpenSans(_ type: OpenSansType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "OpenSans\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}

#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias SFFont = NSFont


extension NSFont {

    public enum OpenSansType: String {
        case extraboldItalic = "-ExtraboldItalic"
        case semiboldItalic = "-SemiboldItalic"
        case semibold = "-Semibold"
        case regular = ""
        case lightItalic = "Light-Italic"
        case light = "-Light"
        case italic = "-Italic"
        case extraBold = "-Extrabold"
        case boldItalic = "-BoldItalic"
        case bold = "-Bold"
    }
    public enum LucidaGrandeType: String {
        case regular = ""
        case bold = "-Bold"
    }
    
    static func OpenSans(_ type: OpenSansType = .regular, size: CGFloat = NSFont.systemFontSize) -> NSFont {
        return NSFont(name: "OpenSans\(type.rawValue)", size: size)!
    }

    static func LucidaGrande(_ type: OpenSansType = .regular, size: CGFloat = NSFont.systemFontSize) -> NSFont {
        return NSFont(name: "LucidaGrande\(type.rawValue)", size: size)!
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.bold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.italic)
    }
    
}
#endif
