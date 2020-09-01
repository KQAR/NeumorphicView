//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/8/31.
//

import UIKit


public class NeumorphicLayer: CALayer {
    
    // MARK: Properties

    private var props: NeumorphicLayerProps?

    public weak var masterView: NeumorphicElementProtocol?
    
    /// Default is 1.
    public var lightShadowOpacity: Float = 1 {
        didSet {
            if oldValue != lightShadowOpacity {
                setNeedsDisplay()
            }
        }
    }
    
    /// Default is 0.3.
    public var darkShadowOpacity: Float = 0.3 {
        didSet {
            if oldValue != darkShadowOpacity {
                setNeedsDisplay()
            }
        }
    }

    /// Optional. if it is nil (default), elementBackgroundColor will be used as element color.
    public var elementColor: CGColor? {
        didSet {
            if oldValue !== elementColor {
                setNeedsDisplay()
            }
        }
    }
    private var elementSelectedColor: CGColor?
    
    /// It will be used as base color for light/shadow. If elementColor is nil, elementBackgroundColor will be used as elementColor.
    public var elementBackgroundColor: CGColor = UIColor.white.cgColor {
        didSet {
            if oldValue !== elementBackgroundColor {
                setNeedsDisplay()
            }
        }
    }
    public var depthType: NeumorphicLayerDepthType = .convex {
        didSet {
            if oldValue != depthType {
                masterView?.depthTypeUpdated(to: depthType)
                setNeedsDisplay()
            }
        }
    }
    
    /// ".all" is for buttons. ".topRowm" ".middleRow" ".bottomRow" is for table cells.
    public var cornerType: NeumorphicLayerCornerType = .all {
        didSet {
            if oldValue != cornerType {
                setNeedsDisplay()
            }
        }
    }
    
    /// Default is 5.
    public var elementDepth: CGFloat = 5 {
        didSet {
            if oldValue != elementDepth {
                setNeedsDisplay()
            }
        }
    }
    
    /// Adding a very thin border on the edge of the element.
    public var edged: Bool = false {
        didSet {
            if oldValue != edged {
                setNeedsDisplay()
            }
        }
    }

    /// If set to true, show element highlight color. Animated.
    public var selected: Bool {
        get {
            return _selected
        }
        set {
            _selected = newValue
            let color = elementColor ?? elementBackgroundColor
            elementSelectedColor = UIColor(cgColor: color).getTransformedColor(saturation: 1, brightness: 0.9).cgColor
            colorLayer?.backgroundColor = _selected ? elementSelectedColor : color
        }
    }
    private var _selected: Bool = false
    
    private var colorLayer: CALayer?
    private var shadowLayer: ShadowLayer?
    private var lightLayer: ShadowLayer?
    private var edgeLayer: EdgeLayer?
    private var darkSideColor: CGColor = UIColor.black.cgColor
    private var lightSideColor: CGColor = UIColor.white.cgColor

    
    // MARK: Build Layers
    
    public override func display() {
        super.display()
        update()
    }
    
    public func update() {
        // check property update
        let isBoundsUpdated: Bool = colorLayer?.bounds != bounds
        var currentProps = NeumorphicLayerProps()
        currentProps.cornerType = cornerType
        currentProps.depthType = depthType
        currentProps.edged = edged
        currentProps.lightShadowOpacity = lightShadowOpacity
        currentProps.darkShadowOpacity = darkShadowOpacity
        currentProps.elementColor = elementColor
        currentProps.elementBackgroundColor = elementBackgroundColor
        currentProps.elementDepth = elementDepth
        currentProps.cornerRadius = cornerRadius
        let isPropsNotChanged = props == nil ? true : currentProps == props!
        if !isBoundsUpdated && isPropsNotChanged {
            return
        }
        props = currentProps

        // generate shadow color
        let color = elementColor ?? elementBackgroundColor
        lightSideColor = UIColor.white.cgColor
        darkSideColor = UIColor(cgColor: elementBackgroundColor).getTransformedColor(saturation: 0.1, brightness: 0).cgColor
 
        // add sublayers
        if colorLayer == nil {
            colorLayer = CALayer()
            colorLayer?.cornerCurve = .continuous
            shadowLayer = ShadowLayer()
            lightLayer = ShadowLayer()
            edgeLayer = EdgeLayer()
            insertSublayer(edgeLayer!, at: 0)
            insertSublayer(colorLayer!, at: 0)
            insertSublayer(lightLayer!, at: 0)
            insertSublayer(shadowLayer!, at: 0)
        }
        colorLayer?.frame = bounds
        colorLayer?.backgroundColor = _selected ? elementSelectedColor : color
        if depthType == .convex {
            masksToBounds = false
            colorLayer?.removeFromSuperlayer()
            insertSublayer(colorLayer!, at: 2)
            colorLayer?.masksToBounds = true
            shadowLayer?.masksToBounds = false
            lightLayer?.masksToBounds = false
            edgeLayer?.masksToBounds = false
        }
        else {
            masksToBounds = true
            colorLayer?.removeFromSuperlayer()
            insertSublayer(colorLayer!, at: 0)
            colorLayer?.masksToBounds = true
            shadowLayer?.masksToBounds = true
            lightLayer?.masksToBounds = true
            edgeLayer?.masksToBounds = true
        }
        
        // initialize sublayers
        shadowLayer?.initialize(bounds: bounds, mode: .darkSide, props: props!, color: darkSideColor)
        lightLayer?.initialize(bounds: bounds, mode: .lightSide, props: props!, color: lightSideColor)

        if currentProps.edged {
            edgeLayer?.initialize(bounds: bounds, props: props!, color: lightSideColor)
        }
        else {
            edgeLayer?.reset()
        }
                
        // set corners and outer mask
        switch cornerType {
        case .all:
            if depthType == .convex {
                colorLayer?.cornerRadius = cornerRadius
            }
        case .topRow:
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            if depthType == .convex {
                colorLayer?.cornerRadius = cornerRadius
                colorLayer?.maskedCorners = maskedCorners
                applyOuterMask(bounds: bounds, props: props!)
            }
            else {
                mask = nil
            }
        case .middleRow:
            maskedCorners = []
            if depthType == .convex {
                applyOuterMask(bounds: bounds, props: props!)
            }
            else {
                mask = nil
            }
        case .bottomRow:
            maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            if depthType == .convex {
                colorLayer?.cornerRadius = cornerRadius
                colorLayer?.maskedCorners = maskedCorners
                applyOuterMask(bounds: bounds, props: props!)
            }
            else {
                mask = nil
            }
        }
    }

    private func applyOuterMask(bounds: CGRect, props: NeumorphicLayerProps) {
        let shadowRadius = props.elementDepth
        let extendWidth = shadowRadius * 2
        var maskFrame = CGRect()
        switch props.cornerType {
        case .all:
            return
        case .topRow:
            maskFrame = CGRect(x: -extendWidth, y: -extendWidth, width: bounds.size.width + extendWidth * 2, height: bounds.size.height + extendWidth)
        case .middleRow:
            maskFrame = CGRect(x: -extendWidth, y: 0, width: bounds.size.width + extendWidth * 2, height: bounds.size.height)
        case .bottomRow:
            maskFrame = CGRect(x: -extendWidth, y: 0, width: bounds.size.width + extendWidth * 2, height: bounds.size.height + extendWidth)
        }
        let maskLayer = CALayer()
        maskLayer.frame = maskFrame
        maskLayer.backgroundColor = UIColor.white.cgColor
        mask = maskLayer
    }
}
