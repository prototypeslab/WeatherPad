import UIKit

extension UIViewController {

    var hasSafeArea: Bool {
        guard
            #available(iOS 11.0, tvOS 11.0, *)
            else {
                return false
            }
        return (viewIfLoaded?.window?.safeAreaInsets.top ?? 0) > 20
    }

}
