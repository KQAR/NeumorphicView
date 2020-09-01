//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/8/31.
//

import UIKit

class EdgeLayer: ShadowLayerBase {
    func initialize(bounds: CGRect, props: NeumorphicLayerProps, color: CGColor) {
        
        setCorner(props: props)
        let corners = EdgeLayer.corners[props.cornerType]!
        
        cornerCurve = .continuous
        shouldRasterize = true
        frame = bounds
        
        var shadowY: CGFloat = 0
        var path: UIBezierPath
        var innerPath: UIBezierPath
        let edgeWidth: CGFloat = 0.75
        
        var edgeBounds = bounds
        let cornerRadii: CGSize = CGSize(width: props.cornerRadius, height: props.cornerRadius)
        let cornerRadiusEdge = props.cornerRadius - edgeWidth
        let cornerRadiiEdge: CGSize = CGSize(width: cornerRadiusEdge, height: cornerRadiusEdge)
        
        if props.depthType == .convex {
            
            switch props.cornerType {
            case .all:
                break
            case .topRow:
                edgeBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height + 2)
            case .middleRow:
                edgeBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - 2, width: bounds.size.width, height: bounds.size.height + 4)
            case .bottomRow:
                edgeBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - 2, width: bounds.size.width, height: bounds.size.height + 2)
            }
            
            path = UIBezierPath(roundedRect: edgeBounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
            let innerPath = UIBezierPath(roundedRect: edgeBounds.insetBy(dx: edgeWidth, dy: edgeWidth),
                                    byRoundingCorners: corners, cornerRadii: cornerRadiiEdge).reversing()
            path.append(innerPath)
            shadowPath = path.cgPath
            shadowColor = color
            shadowOffset = CGSize.zero
            shadowOpacity = min(props.lightShadowOpacity * 1.5, 1)
            shadowRadius = 0
        }
        else {
            // shadow size and y position
            if props.depthType == .concave {
                switch props.cornerType {
                case .all:
                    break
                case .topRow:
                    edgeBounds.size.height += 2
                case .middleRow:
                    shadowY = -5
                    edgeBounds.size.height += 10
                case .bottomRow:
                    shadowY = -2
                    edgeBounds.size.height += 2
                }
            }
            // shadow path
            if props.cornerType == .middleRow {
                path = UIBezierPath(rect: edgeBounds)
                innerPath = UIBezierPath(rect: edgeBounds.insetBy(dx: edgeWidth, dy: edgeWidth)).reversing()
            }
            else {
                path = UIBezierPath(roundedRect: edgeBounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
                innerPath = UIBezierPath(roundedRect: edgeBounds.insetBy(dx: edgeWidth, dy: edgeWidth),
                                        byRoundingCorners: corners, cornerRadii: cornerRadiiEdge).reversing()
            }
            
            path.append(innerPath)
            shadowPath = path.cgPath
            shadowColor = color
            shadowOffset = CGSize(width: 0, height: shadowY)
            shadowOpacity = min(props.lightShadowOpacity * 1.5, 1)
            shadowRadius = 0
        }
    }
    func reset() {
        shadowPath = nil
        shadowOffset = CGSize.zero
        shadowOpacity = 0
        frame = CGRect()
    }
}
