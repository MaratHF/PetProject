//
//  PillMarker.swift
//  PetProject
//
//  Created by MAC  on 10.07.2022.
//

import Foundation
import Charts

class PillMarker: MarkerImage {

    private (set) var color: UIColor
    private (set) var font: UIFont
    private (set) var textColor: UIColor
    private var x: CGFloat
    private var y: CGFloat
    private var width: CGFloat
    private var labelText: String = ""
    private var attrs: [NSAttributedString.Key: AnyObject]!

    init(color: UIColor, font: UIFont, textColor: UIColor, x: CGFloat, y: CGFloat, width: CGFloat) {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.x = x
        self.y = y
        self.width = width
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrs = [.font: font, .paragraphStyle: paragraphStyle, .foregroundColor: textColor, .baselineOffset: NSNumber(value: -4)]
        super.init()
    }

    override func draw(context: CGContext, point: CGPoint) {
        if labelText != "" {
        // if you modify labelHeigh you will have to tweak baselineOffset in attrs
        let labelHeight = labelText.size(withAttributes: attrs).height + 4

        // place pill above the marker, centered along x
        let rectangle = CGRect(x: x, y: y, width: width, height: labelHeight)

        // rounded rect
        let clipPath = UIBezierPath(roundedRect: rectangle, cornerRadius: 6.0).cgPath
        context.addPath(clipPath)
        context.setFillColor(UIColor.gray.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.closePath()
        context.drawPath(using: .fillStroke)

        // add the text
        labelText.draw(with: rectangle, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let hours = Int(entry.y)
        let minutes = (entry.y - Double(hours)) * 60
        
        if entry.y != 0 {
            labelText = "Длительность сна \(hours) часов \(Int(round(minutes))) минут"
        } else {
            labelText = ""
        }
    }
}
