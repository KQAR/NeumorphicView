//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/8/31.
//

import UIKit

class GradientMaskLayer: CALayer {
    required override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(layer: Any) {
        super.init(layer: layer)
    }
 
    var cornerType: NeumorphicLayerCornerType = .all
    var shadowLayerMode: ShadowLayerMode = .lightSide
    var shadowCornerRadius: CGFloat = 0

    private func getTopRightCornerRect(size: CGSize, radius: CGFloat) -> CGRect {
        return CGRect(x: size.width - radius, y: 0, width: radius, height: radius)
    }
    private func getBottomLeftCornerRect(size: CGSize, radius: CGFloat) -> CGRect {
        return CGRect(x: 0, y: size.height - radius, width: radius, height: radius)
    }

    override func draw(in ctx: CGContext) {
        let rectTR = getTopRightCornerRect(size: frame.size, radius: shadowCornerRadius)
        let rectTR_BR = CGPoint(x: rectTR.maxX, y: rectTR.maxY)
        let rectBL = getBottomLeftCornerRect(size: frame.size, radius: shadowCornerRadius)
        let rectBL_BR = CGPoint(x: rectBL.maxX, y: rectBL.maxY)
        
        let color = UIColor.black.cgColor
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: [color, UIColor.clear.cgColor] as CFArray,
                                        locations: [0, 1]) else { return }

        
        if cornerType == .all {
            if shadowLayerMode == .lightSide {
                if frame.size.width > shadowCornerRadius * 2 && frame.size.height > shadowCornerRadius * 2 {
                    ctx.setFillColor(color)
                    ctx.fill(CGRect(x: shadowCornerRadius,
                                    y: shadowCornerRadius,
                                    width: frame.size.width - shadowCornerRadius,
                                    height: frame.size.height - shadowCornerRadius)
                    )
                }
                ctx.saveGState()
                ctx.addRect(rectTR)
                ctx.clip()
                ctx.drawLinearGradient(gradient, start: rectTR_BR, end: rectTR.origin, options: [])
                ctx.restoreGState()
                ctx.saveGState()
                ctx.addRect(rectBL)
                ctx.clip()
                ctx.drawLinearGradient(gradient, start: rectBL_BR, end: rectBL.origin, options: [])
                ctx.restoreGState()
            }
            else {
                if frame.size.width > shadowCornerRadius * 2 && frame.size.height > shadowCornerRadius * 2 {
                    ctx.setFillColor(color)
                    ctx.fill(CGRect(x: 0,
                                    y: 0,
                                    width: frame.size.width - shadowCornerRadius,
                                    height: frame.size.height - shadowCornerRadius)
                    )
                }
                ctx.saveGState()
                ctx.addRect(rectTR)
                ctx.clip()
                ctx.drawLinearGradient(gradient, start: rectTR.origin, end: rectTR_BR, options: [])
                ctx.restoreGState()
                ctx.saveGState()
                ctx.addRect(rectBL)
                ctx.clip()
                ctx.drawLinearGradient(gradient, start: rectBL.origin, end: rectBL_BR, options: [])
                ctx.restoreGState()
            }
        }
        else if cornerType == .topRow {
            if shadowLayerMode == .lightSide {
                ctx.setFillColor(color)
                ctx.fill(CGRect(x: frame.size.width - shadowCornerRadius,
                                y: shadowCornerRadius,
                                width: frame.size.width,
                                height: frame.size.height - shadowCornerRadius)
                )
                ctx.saveGState()
                ctx.addRect(rectTR)
                ctx.clip()
                ctx.drawLinearGradient(gradient, start: rectTR_BR, end: rectTR.origin, options: [])
                ctx.restoreGState()
            }
            else {
                ctx.setFillColor(color)
                ctx.fill(CGRect(x: 0,
                                y: 0,
                                width: frame.size.width - shadowCornerRadius,
                                height: frame.size.height)
                )
                ctx.saveGState()
                ctx.addRect(rectTR)
                ctx.clip()
                ctx.drawLinearGradient(gradient, start: rectTR.origin, end: rectTR_BR, options: [])
                ctx.restoreGState()
            }
        }
        else if cornerType == .bottomRow {
            ctx.setFillColor(color)
            if shadowLayerMode == .lightSide {
                ctx.fill(CGRect(x: shadowCornerRadius,
                                y: 0,
                                width: frame.size.width - shadowCornerRadius,
                                height: frame.size.height)
                )
                ctx.saveGState()
                ctx.addRect(rectBL)
                ctx.clip()
                ctx.drawLinearGradient(gradient, start: rectBL_BR, end: rectBL.origin, options: [])
                ctx.restoreGState()
            }
            else {
                ctx.fill(CGRect(x: 0,
                                y: 0,
                                width: shadowCornerRadius,
                                height: frame.size.height - shadowCornerRadius)
                )
                ctx.saveGState()
                ctx.addRect(rectBL)
                ctx.clip()
                ctx.drawLinearGradient(gradient, start: rectBL.origin, end: rectBL_BR, options: [])
                ctx.restoreGState()
            }
        }
    }
}
