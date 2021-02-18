//
//  UIUtilities.swift
//  Translate Camera
//
//  Created by Maksym on 17.01.2021.
//

import Foundation
import UIKit
import AVFoundation
import UIImageColors


class UIUtilities {

    static func addCircle(
        atPoint point: CGPoint,
        to view: UIView,
        color: UIColor,
        radius: CGFloat
    ) {
        let divisor: CGFloat = 2.0
        let xCoord = point.x - radius / divisor
        let yCoord = point.y - radius / divisor
        let circleRect = CGRect(x: xCoord, y: yCoord, width: radius, height: radius)
        guard circleRect.isValid() else { return }
        let circleView = UIView(frame: circleRect)
        circleView.layer.cornerRadius = radius / divisor
        circleView.alpha = UIConstants.circleViewAlpha
        circleView.backgroundColor = color
        view.addSubview(circleView)
    }
    
    static func addLineSegment(
        fromPoint: CGPoint, toPoint: CGPoint, inView: UIView, color: UIColor, width: CGFloat
    ) {
        let path = UIBezierPath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = color.cgColor
        lineLayer.fillColor = nil
        lineLayer.opacity = 1.0
        lineLayer.lineWidth = width
        let lineView = UIView()
        lineView.layer.addSublayer(lineLayer)
        inView.addSubview(lineView)
    }
    
    static func addRectangle(_ rectangle: CGRect, to view: UIView, color: UIColor, text: String = "", secColor: UIColor = .green) {
        guard rectangle.isValid() else { return }
        let rectangleView = UIView(frame: rectangle)
        rectangleView.backgroundColor = color
        let label = UILabel(frame: rectangle)
        if color.isLight {
            label.textColor = .black
        } else {
            label.textColor = .white
        }
        label.backgroundColor = color
        label.text = text
        label.textColor = secColor
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .justified
//        view.addSubview(rectangleView)
        view.addSubview(label)

    }
    
    static func addShape(withPoints points: [NSValue]?, to view: UIView, color: UIColor) {
        guard let points = points else { return }
        let path = UIBezierPath()
        for (index, value) in points.enumerated() {
            let point = value.cgPointValue
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            if index == points.count - 1 {
                path.close()
            }
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        let rect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        let shapeView = UIView(frame: rect)
        shapeView.alpha = UIConstants.shapeViewAlpha
        shapeView.layer.addSublayer(shapeLayer)
        view.addSubview(shapeView)
    }
    
    
    
    static func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)

        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)

        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return inputImage
        }

        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    static func transformMatrix(imageView: UIImageView) -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale =
            (imageViewAspectRatio > imageAspectRatio)
            ? imageViewHeight / imageHeight : imageViewWidth / imageWidth
        
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
        
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    
    
    static func findColors(_ image: UIImage) -> [UIColor] {
        let pixelsWide = Int(image.size.width)
        let pixelsHigh = Int(image.size.height)

        guard let pixelData = image.cgImage?.dataProvider?.data else { return [] }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var imageColors: [UIColor] = []
        for x in 0..<pixelsWide {
            for y in 0..<pixelsHigh {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((pixelsWide * Int(point.y)) + Int(point.x)) * 4
                let color = UIColor(red: CGFloat(data[pixelInfo]) / 255.0,
                                    green: CGFloat(data[pixelInfo + 1]) / 255.0, 
                                    blue: CGFloat(data[pixelInfo + 2]) / 255.0,
                                    alpha: CGFloat(data[pixelInfo + 3]) / 255.0)
                imageColors.append(color)
            }
        }
        return imageColors
    }
    
    
    static func getColorFromImage(image: UIImageView, rect: CGRect) -> UIColor {
        let cropedImage = cropImage(image.image!, toRect: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width+20, height: rect.height), viewWidth: image.frame.width, viewHeight: image.frame.height)
//        let colors = findColors(cropImage(image.image!, toRect: rect, viewWidth: image.frame.width, viewHeight: image.frame.height))
//        let mappedItems = colors.map { ($0, 1) }
//        let counts = Dictionary(mappedItems, uniquingKeysWith: +)
//        let sortedByValueDictionary = counts.sorted { $0.1 > $1.1 }
//
//        print("Dict: \(sortedByValueDictionary)")
//        print("counts of item: \(sortedByValueDictionary.first!.key)")
        let color = cropedImage.getColors()?.background
        //        let color = sortedByValueDictionary.first!.key
        return color!

    }
    
    static func getColorOfFontFromImage(image: UIImageView, rect: CGRect) -> UIColor {
        let cropedImage = cropImage(image.image!, toRect: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width+20, height: rect.height), viewWidth: image.frame.width, viewHeight: image.frame.height)
//        let colors = findColors(cropImage(image.image!, toRect: rect, viewWidth: image.frame.width, viewHeight: image.frame.height))
//        let mappedItems = colors.map { ($0, 1) }
//        let counts = Dictionary(mappedItems, uniquingKeysWith: +)
//        let sortedByValueDictionary = counts.sorted { $0.1 > $1.1 }
//
//        print("Dict: \(sortedByValueDictionary)")
//        print("counts of item: \(sortedByValueDictionary.first!.key)")
        let color = cropedImage.getColors()?.secondary
        //        let color = sortedByValueDictionary.first!.key
        return color!

    }
    
}

// MARK: - Constants

private enum UIConstants {
    static let circleViewAlpha: CGFloat = 0.7
    static let rectangleViewAlpha: CGFloat = 0.4
    static let shapeViewAlpha: CGFloat = 0.3
    static let rectangleViewCornerRadius: CGFloat = 10.0
}


