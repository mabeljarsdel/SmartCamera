//
//  CropBox.swift
//  Translate Camera
//
//  Created by Maksym on 30.01.2021.
//

import Foundation
import UIKit
import SnapKit

class ResizableView: UIView {

    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, none
    }

    
    static var edgeSize: CGFloat = 50.0
    private typealias `Self` = ResizableView

    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    
    
    var defaultCenter: CGPoint?
    var defaultSizeWidth: CGFloat?
    var defaultSizeHeight: CGFloat?
    
    
    var gridLinesAlpha: CGFloat = 0 {
        didSet {
            gridLinesView.alpha = gridLinesAlpha
        }
    }

    var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    lazy var gridLinesView: Grid = {
        let view = Grid(frame: bounds)
        view.backgroundColor = UIColor.clear
        view.alpha = 0
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin, .flexibleBottomMargin, .flexibleRightMargin]
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        clipsToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        autoresizingMask = UIView.AutoresizingMask(rawValue: 0)
        addSubview(gridLinesView)

        setupCorners()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    func setupCorners() {
        let offset: CGFloat = -1

        let topLeft = CornerView(.topLeft)
        topLeft.center = CGPoint(x: offset, y: offset)
        topLeft.autoresizingMask = UIView.AutoresizingMask(rawValue: 0)
        addSubview(topLeft)

        let topRight = CornerView(.topRight)
        topRight.center = CGPoint(x: frame.size.width - offset, y: offset)
        topRight.autoresizingMask = .flexibleLeftMargin
        addSubview(topRight)

        let bottomRight = CornerView(.bottomRight)
        bottomRight.center = CGPoint(x: frame.size.width - offset, y: frame.size.height - offset)
        bottomRight.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        addSubview(bottomRight)

        let bottomLeft = CornerView(.bottomLeft)
        bottomLeft.center = CGPoint(x: offset, y: frame.size.height - offset)
        bottomLeft.autoresizingMask = .flexibleTopMargin
        addSubview(bottomLeft)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gridLinesView.frame = bounds
        gridLinesView.setNeedsDisplay()
    }
    
    //MARK: - Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            touchStart = touch.location(in: self)

            currentEdge = {
                if self.bounds.size.width - touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                    return .bottomRight
                } else if touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                    return .topLeft
                } else if self.bounds.size.width-touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                    return .topRight
                } else if touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                    return .bottomLeft
                }
                return .none
            }()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            print(self.frame)
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)

            let originX = self.center.x
            let originY = self.center.y
            let width = self.frame.size.width
            let height = self.frame.size.height

            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = (currentPoint.y - previous.y)
            
            var newWidth: CGFloat
            var newHeight: CGFloat
            var newX: CGFloat
            var newY: CGFloat
            
            switch currentEdge {
            
            case .topLeft:
                newWidth = width - deltaWidth
                newHeight = height - deltaHeight
                newX = originX + (deltaWidth)/2
                newY = originY + (deltaHeight)/2
                
            case .topRight:
                newWidth = width + deltaWidth
                newHeight = height - deltaHeight
                newX = originX + (deltaWidth)/2
                newY = originY + (deltaHeight)/2
                
            case .bottomRight:
                newWidth = width + deltaWidth
                newHeight = height + deltaHeight
                newX = originX + (deltaWidth)/2
                newY = originY + (deltaHeight)/2

            case .bottomLeft:
                newWidth = width - deltaWidth
                newHeight = height + deltaHeight
                newX = originX + (deltaWidth)/2
                newY = originY + (deltaHeight)/2

            default:
                newWidth = width
                newHeight = height
                newX = self.center.x + currentPoint.x - touchStart.x
                newY = self.center.y + currentPoint.y - touchStart.y
            }
            
            
            //MARK: Bounds
            
            if newWidth < 100 {
                newWidth = 100
            }
            
            
            if newHeight < 100 {
                newHeight = 100
            }
            
            if newHeight > defaultSizeHeight! * 2 {
                newHeight = defaultSizeHeight! * 2
            }
            
            if newWidth > defaultSizeWidth! * 2 {
                newWidth = defaultSizeWidth! * 2
            }
            
            if newX < defaultCenter!.x -  defaultSizeWidth!/2 - (defaultSizeWidth! - newWidth)/2 {
                newX = defaultCenter!.x -  defaultSizeWidth!/2 - (defaultSizeWidth! - newWidth)/2
            }
            
            if newX > defaultCenter!.x +  defaultSizeWidth!/2 + (defaultSizeWidth! - newWidth)/2 {
                newX = defaultCenter!.x +  defaultSizeWidth!/2 + (defaultSizeWidth! - newWidth)/2
            }
            
            if newY < defaultCenter!.y -  defaultSizeHeight!/2 - (defaultSizeHeight! - newHeight)/2 {
                newY = defaultCenter!.y -  defaultSizeHeight!/2 - (defaultSizeHeight! - newHeight)/2
            }
            
            if newY > defaultCenter!.y +  defaultSizeHeight!/2 + (defaultSizeHeight! - newHeight)/2 {
                newY = defaultCenter!.y +  defaultSizeHeight!/2 + (defaultSizeHeight! - newHeight)/2
            }
            
            //add bounds
            
            snp.updateConstraints { make in
                make.width.equalTo(newWidth)
                make.height.equalTo(newHeight)
                make.centerX.equalTo(newX)
                make.centerY.equalTo(newY)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentEdge = .none
        
    }
}



// MARK: CornerType
extension ResizableView {
    enum CornerType {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
}

// MARK: CornerView
extension ResizableView {
    class CornerView: UIView {

        let cornerSize: CGFloat = 20

        init(_ type: CornerType) {
            super.init(frame: CGRect(x: 0, y: 0, width: cornerSize, height: cornerSize))

            backgroundColor = UIColor.clear

            let lineWidth: CGFloat = 2 + 1.0 / UIScreen.main.scale
            let lineColor: UIColor = .white

            let horizontal = UIView(frame: CGRect(x: 0, y: 0, width: cornerSize, height: lineWidth))
            horizontal.backgroundColor = lineColor
            addSubview(horizontal)

            let vertical = UIView(frame: CGRect(x: 0, y: 0, width: lineWidth, height: cornerSize))
            vertical.backgroundColor = lineColor
            addSubview(vertical)

            let shortMid = lineWidth / 2 // mid of short side of line rect
            let longMid = cornerSize / 2 // mid of long side of line rect
            switch type {
            case .topLeft:
                horizontal.center = CGPoint(x: longMid, y: shortMid)
                vertical.center = CGPoint(x: shortMid, y: longMid)
                layer.anchorPoint = CGPoint(x: shortMid / cornerSize, y: shortMid / cornerSize)
            case .topRight:
                horizontal.center = CGPoint(x: longMid, y: shortMid)
                vertical.center = CGPoint(x: cornerSize - shortMid, y: longMid)
                layer.anchorPoint = CGPoint(x: 1 - shortMid / cornerSize, y: shortMid / cornerSize)
            case .bottomLeft:
                horizontal.center = CGPoint(x: longMid, y: cornerSize - shortMid)
                vertical.center = CGPoint(x: shortMid, y: longMid)
                layer.anchorPoint = CGPoint(x: shortMid / cornerSize, y: 1 - shortMid / cornerSize)
            case .bottomRight:
                horizontal.center = CGPoint(x: longMid, y: cornerSize - shortMid)
                vertical.center = CGPoint(x: cornerSize - shortMid, y: longMid)
                layer.anchorPoint = CGPoint(x: 1 - shortMid / cornerSize, y: 1 - shortMid / cornerSize)
            }
        }

        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


class Grid: UIView {

    public var horizontalLinesCount: UInt = 2 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var verticalLinesCount: UInt = 2 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var lineColor: UIColor = UIColor(white: 1, alpha: 0.7) {
        didSet {
            setNeedsDisplay()
        }
    }

    public var lineWidth: CGFloat = 1.0 / UIScreen.main.scale {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)

        let horizontalLineSpacing = frame.size.width / CGFloat(horizontalLinesCount + 1)
        let verticalLineSpacing = frame.size.height / CGFloat(verticalLinesCount + 1)

        for i in 1 ..< horizontalLinesCount + 1 {
            context.move(to: CGPoint(x: CGFloat(i) * horizontalLineSpacing, y: 0))
            context.addLine(to: CGPoint(x: CGFloat(i) * horizontalLineSpacing, y: frame.size.height))
        }

        for i in 1 ..< verticalLinesCount + 1 {
            context.move(to: CGPoint(x: 0, y: CGFloat(i) * verticalLineSpacing))
            context.addLine(to: CGPoint(x: frame.size.width, y: CGFloat(i) * verticalLineSpacing))
        }

        context.strokePath()
    }
}
