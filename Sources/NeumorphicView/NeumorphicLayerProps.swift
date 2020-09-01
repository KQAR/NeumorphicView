//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/8/31.
//

import UIKit
import Foundation

struct NeumorphicLayerProps {
    
    var lightShadowOpacity: Float = 1
    var darkShadowOpacity: Float = 0.3
    var elementColor: CGColor?
    var elementBackgroundColor: CGColor = UIColor.white.cgColor
    var depthType: NeumorphicLayerDepthType = .convex
    var cornerType: NeumorphicLayerCornerType = .all
    var elementDepth: CGFloat = 5
    var edged: Bool = false
    var cornerRadius: CGFloat = 0
    
    static func == (lhs: NeumorphicLayerProps, rhs: NeumorphicLayerProps) -> Bool {
        return lhs.lightShadowOpacity == rhs.lightShadowOpacity &&
            lhs.darkShadowOpacity == rhs.darkShadowOpacity &&
            lhs.elementColor === rhs.elementColor &&
            lhs.elementBackgroundColor === rhs.elementBackgroundColor &&
            lhs.depthType == rhs.depthType &&
            lhs.cornerType == rhs.cornerType &&
            lhs.elementDepth == rhs.elementDepth &&
            lhs.edged == rhs.edged &&
            lhs.cornerRadius == rhs.cornerRadius
    }
}
