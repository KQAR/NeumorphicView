//
//  File.swift
//  
//
//  Created by 金瑞 on 2020/9/1.
//

import UIKit

public class NeumorphicTableCell: UITableViewCell, NeumorphicElementProtocol {

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// Change effects via its properties.
    public var neumorphicLayer: NeumorphicLayer? {
        if bg == nil {
            bg = NeumorphicView(frame: bounds)
            bg?.neumorphicLayer?.masterView = self
            selectedBackgroundView = UIView()
            layer.masksToBounds = true
            backgroundView = bg
        }
        return bg?.neumorphicLayer
    }
    private var bg: NeumorphicView?
    public override func layoutSubviews() {
        super.layoutSubviews()
        neumorphicLayer?.update()
    }
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        neumorphicLayer?.selected = highlighted
    }
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        neumorphicLayer?.selected = selected
    }
    public func depthTypeUpdated(to type: NeumorphicLayerDepthType) {
        if let l = bg?.neumorphicLayer {
            layer.masksToBounds = l.depthType == .concave
        }
    }
}
