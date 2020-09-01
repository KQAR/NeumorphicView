//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/8/31.
//

import UIKit

class ShadowLayer: ShadowLayerBase {

    private var lightLayer: CALayer?
    
    func initialize(bounds: CGRect, mode: ShadowLayerMode, props: NeumorphicLayerProps, color: CGColor) {
        cornerCurve = .continuous
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
        if props.depthType == .convex {
            applyOuterShadow(bounds: bounds, mode: mode, props: props, color: color)
        }
        else { // .concave
            applyInnerShadow(bounds: bounds, mode: mode, props: props, color: color)
        }
    }
    
    func applyOuterShadow(bounds: CGRect, mode: ShadowLayerMode, props: NeumorphicLayerProps, color: CGColor) {
        
        lightLayer?.removeFromSuperlayer()
        lightLayer = nil
        
        frame = bounds
        cornerRadius = 0
        maskedCorners = []
        masksToBounds = false
        mask = nil
        
        let shadowCornerRadius = props.cornerType == .middleRow ? 0 : props.cornerRadius
        
        // prepare shadow parameters
        let shadowRadius = props.elementDepth
        let offsetWidth: CGFloat = shadowRadius / 2
        let cornerRadii: CGSize = props.cornerRadius <= 0 ? CGSize.zero : CGSize(width: shadowCornerRadius - offsetWidth, height: shadowCornerRadius - offsetWidth)
    
        var shadowX: CGFloat = 0
        var shadowY: CGFloat = 0
        if mode == .lightSide {
            shadowY = -offsetWidth
            shadowX = -offsetWidth
        }
        else {
            shadowY = offsetWidth
            shadowX = offsetWidth
        }
   
        setCorner(props: props)
        let corners = ShadowLayer.corners[props.cornerType]!
   
        let extendHeight = max(props.cornerRadius, shadowCornerRadius)
        
        // add shadow
        var shadowBounds = bounds
        switch props.cornerType {
        case .all:
            break
        case .topRow:
            shadowBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height + extendHeight)
        case .middleRow:
            shadowY = 0
            shadowBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - extendHeight, width: bounds.size.width, height: bounds.size.height + extendHeight * 2)
        case .bottomRow:
            shadowBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - extendHeight, width: bounds.size.width, height: bounds.size.height + extendHeight)
        }

        let path: UIBezierPath = UIBezierPath(roundedRect: shadowBounds.insetBy(dx: offsetWidth, dy: offsetWidth),
                                              byRoundingCorners: corners,
                                              cornerRadii: cornerRadii)
        shadowPath = path.cgPath
        shadowColor = color
        shadowOffset = CGSize(width: shadowX, height: shadowY)
        shadowOpacity = mode == .lightSide ? props.lightShadowOpacity : props.darkShadowOpacity
        self.shadowRadius = shadowRadius
    }

    func applyInnerShadow(bounds: CGRect, mode: ShadowLayerMode, props: NeumorphicLayerProps, color: CGColor) {
        let width = bounds.size.width
        let height = bounds.size.height
        
        frame = bounds
        
        // prepare shadow parameters
        let shadowRadius = props.elementDepth * 0.75

        let gap: CGFloat = 1

        let cornerRadii: CGSize = CGSize(width: props.cornerRadius + gap, height: props.cornerRadius + gap)
        let cornerRadiusInner = props.cornerRadius - gap
        let cornerRadiiInner: CGSize = CGSize(width: cornerRadiusInner, height: cornerRadiusInner)
        var shadowX: CGFloat = 0
        var shadowY: CGFloat = 0
        var shadowWidth: CGFloat = width
        var shadowHeight: CGFloat = height

        setCorner(props: props)
        let corners = ShadowLayer.corners[props.cornerType]!
        
        switch props.cornerType {
        case .all:
            break
        case .topRow:
            shadowHeight += shadowRadius * 4
        case .middleRow:
            if mode == .lightSide {
                shadowWidth += shadowRadius * 3
                shadowHeight += shadowRadius * 6
                shadowY = -(shadowRadius * 3)
                shadowX = -(shadowRadius * 3)
            }
            else {
                shadowWidth += shadowRadius * 2
                shadowHeight += shadowRadius * 6
                shadowY -= (shadowRadius * 3)
            }
        case .bottomRow:
            shadowHeight += shadowRadius * 4
            shadowY = -shadowRadius * 4
        }

        // add shadow
        let shadowBounds = CGRect(x: 0, y: 0, width: shadowWidth, height: shadowHeight)
        var path: UIBezierPath
        var innerPath: UIBezierPath
        
        if props.cornerType == .middleRow {
            path = UIBezierPath(rect: shadowBounds.insetBy(dx: -gap, dy: -gap))
            innerPath = UIBezierPath(rect: shadowBounds.insetBy(dx: gap, dy: gap)).reversing()
        }
        else {
            path = UIBezierPath(roundedRect:shadowBounds.insetBy(dx: -gap, dy: -gap),
                                byRoundingCorners: corners,
                                cornerRadii: cornerRadii)
            innerPath = UIBezierPath(roundedRect: shadowBounds.insetBy(dx: gap, dy: gap),
                                     byRoundingCorners: corners,
                                     cornerRadii: cornerRadiiInner).reversing()
        }
        path.append(innerPath)

        shadowPath = path.cgPath
        masksToBounds = true
        shadowColor = color
        shadowOffset = CGSize(width: shadowX, height: shadowY)
        shadowOpacity = mode == .lightSide ? props.lightShadowOpacity : props.darkShadowOpacity
        self.shadowRadius = shadowRadius
        
        if mode == .lightSide {
            if lightLayer == nil {
                lightLayer = CALayer()
                addSublayer(lightLayer!)
            }
            lightLayer?.frame = bounds
            lightLayer?.shadowPath = path.cgPath
            lightLayer?.masksToBounds = true
            lightLayer?.shadowColor = shadowColor
            lightLayer?.shadowOffset = CGSize(width: shadowX, height: shadowY)
            lightLayer?.shadowOpacity = props.lightShadowOpacity
            lightLayer?.shadowRadius = shadowRadius
            lightLayer?.shouldRasterize = true
        }
        
        // add mask to shadow
        if props.cornerType == .middleRow {
            mask = nil
        }
        else {
            let maskLayer = GradientMaskLayer()
            maskLayer.frame = bounds
            maskLayer.cornerType = props.cornerType
            maskLayer.shadowLayerMode = mode
            maskLayer.shadowCornerRadius = props.cornerRadius
            mask = maskLayer
        }
    }
}
