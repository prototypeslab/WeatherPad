
import UIKit

@IBDesignable
class SGSegmentView: UIView {
    
    enum Orientation {
        case horizontal
        case vertical
        case null
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.clear {
        didSet {
            currentStateColor = fillColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var strokeColor: UIColor = UIColor.clear {
        didSet {
            strokeColor = .clear
            setNeedsDisplay()
        }
    }
    
    
    private var currentStateColor: UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
            UIView.transition(with: self,
                              duration: 0.36,
                              options: .transitionCrossDissolve,
                              animations: { 
                                self.layer.displayIfNeeded()
            }, completion: nil)
        }
    }
    
    override func layoutSubviews() {
        let h = self.frame.size.height
        let w = self.frame.size.width
        
        orientation = w > h ? .horizontal : .vertical
        switch orientation {
        case .horizontal:
            length = w
            breadth = h
        case .vertical:
            length = h
            breadth = w
        default:
            length = w
            breadth = h
        }
        setNeedsDisplay()
    }
    
    /**
     Used to set and check the state of a segment.
     
     **true** = on      ( fillColor = fillColor )
     
     **false** = off    ( fillColor = strokeColor )
    */
    public var state: Bool = true {
        didSet {
            self.currentStateColor = state ? self.fillColor : .clear
        }
    }
    
    private var breadth: CGFloat = 5.0
    
    private var length: CGFloat = 25.0
    
    private var cutoff: CGFloat { return breadth/2 }
    
    private var strokeWidth: CGFloat {
        
        return breadth/10
        
    }
    
    private var orientation: Orientation
    
    override init(frame: CGRect) {
        let h = frame.size.height
        let w = frame.size.width
        
        orientation = w > h ? .horizontal : .vertical
        switch orientation {
        case .horizontal:
            length = w
            breadth = h
        case .vertical:
            length = h
            breadth = w
        default:
            length = w
            breadth = h
        }
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        orientation = .null
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(strokeColor.cgColor)
       
        context?.setLineWidth(1)
        context?.setFillColor(currentStateColor.cgColor)
        
        let offset = strokeWidth/2
        
        switch orientation {
        case .horizontal:
            context?.move(to: CGPoint(x: cutoff, y: offset))
            context?.addLine(to: CGPoint(x: length - cutoff, y: offset))
            context?.addLine(to: CGPoint(x: length - offset, y: breadth/2))
            context?.addLine(to: CGPoint(x: length - cutoff, y: breadth - offset))
            context?.addLine(to: CGPoint(x: cutoff, y: breadth - offset))
            context?.addLine(to: CGPoint(x: offset, y: breadth/2))
            
        case .vertical:
            context?.move(to: CGPoint(x: offset, y: cutoff))
            context?.addLine(to: CGPoint(x: offset, y: length - cutoff))
            context?.addLine(to: CGPoint(x: breadth/2, y: length - offset))
            context?.addLine(to: CGPoint(x: breadth - offset, y: length - cutoff))
            context?.addLine(to: CGPoint(x: breadth - offset, y: cutoff))
            context?.addLine(to: CGPoint(x: breadth/2, y: offset))
            
        case .null:
            return
        }
        
        context?.closePath()
        context?.drawPath(using: .fillStroke)
    }
    
    override var description: String {
        return "\(orientation) > (\(breadth), \(length))"
    }
}
