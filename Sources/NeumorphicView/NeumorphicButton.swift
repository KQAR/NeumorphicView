//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/9/1.
//

import UIKit

public class NeumorphicButton: UIButton, NeumorphicElementProtocol {
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
    public override var isHighlighted: Bool {
        didSet {
            if oldValue != isHighlighted {
                neumorphicLayer?.selected = isHighlighted
            }
        }
    }
    public override var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                neumorphicLayer?.depthType = isSelected ? .concave : .convex
            }
        }
    }
}
