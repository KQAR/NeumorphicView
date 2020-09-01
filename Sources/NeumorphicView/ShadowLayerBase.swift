//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/8/31.
//

import UIKit

enum ShadowLayerMode: Int {
    case lightSide
    case darkSide
}

class ShadowLayerBase: CALayer {
    
    static let corners: [NeumorphicLayerCornerType: UIRectCorner] = [
        .all: [.topLeft, .topRight, .bottomLeft, .bottomRight],
        .topRow: [.topLeft, .topRight],
        .middleRow: [],
        .bottomRow: [.bottomLeft, .bottomRight]
    ]
    
    func setCorner(props: NeumorphicLayerProps) {
        switch props.cornerType {
        case .all:
            cornerRadius = props.cornerRadius
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .topRow:
            cornerRadius = props.cornerRadius
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .middleRow:
            cornerRadius = 0
            maskedCorners = []
        case .bottomRow:
            cornerRadius = props.cornerRadius
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}
