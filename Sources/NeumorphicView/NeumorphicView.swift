
import UIKit

public class NeumorphicView: UIView, NeumorphicElementProtocol {
    /// Change effects via its properties.
    public var neumorphicLayer: NeumorphicLayer? {
        return layer as? NeumorphicLayer
    }
    public override class var layerClass: AnyClass {
        return NeumorphicLayer.self
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        neumorphicLayer?.update()
    }
}
