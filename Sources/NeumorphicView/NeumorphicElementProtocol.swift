//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/8/31.
//

import UIKit

public enum NeumorphicLayerDepthType: Int {
    case concave
    case convex
}

public enum NeumorphicLayerCornerType: Int {
    case all
    case topRow
    case middleRow
    case bottomRow
}

public protocol NeumorphicElementProtocol: UIView {
    
    var neumorphicLayer: NeumorphicLayer? { get }
    
    func depthTypeUpdated(to type: NeumorphicLayerDepthType)
}

public extension NeumorphicElementProtocol {
    func depthTypeUpdated(to type: NeumorphicLayerDepthType) {
        
    }
}
