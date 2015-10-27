//
//  WZRotateControl.swift
//  RotateControl
//
//  Created by z on 15/10/26.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

import UIKit

func toRadian(val:Double) -> Double {
    return val * M_PI / 180
}

func toDegree(val:Double) -> Double {
    return val * 180 / M_PI
}


protocol WZRotateSliderDataSource {
    func sliderDidUpdateValue(slider:WZRotateSlider, value:Int) -> Void;
}

class WZRotateSlider : UIView {
    
    struct WZRotateSliderConfig {
        static let LineWidth:CGFloat = 40
        static let Padding:CGFloat = 60
        static let FontSize:CGFloat = 40
    }
    
    var delegate:WZRotateSliderDataSource?
    private var textField:UITextField
    private var radius:CGFloat = 0
    private var angle:Int = 0
    private var startColor = UIColor.redColor()
    private var endColor = UIColor.blueColor()
    
    convenience init(frame:CGRect, _ radius: CGFloat?, _ startColor:UIColor, _ endColor:UIColor) {
        self.init(frame:frame)
        
        self.startColor = startColor
        self.endColor = endColor
    }
    
    override init(frame: CGRect) {
        let str = "000" as NSString
        let fontSize:CGSize = str.sizeWithAttributes(
            [NSFontAttributeName:UIFont(
                name: "Avenir",
                size: WZRotateSliderConfig.FontSize)!
            ]
        )
        let textFieldRect = CGRectMake(
            (frame.size.width  - fontSize.width) / 2.0,
            (frame.size.height - fontSize.height) / 2.0,
            fontSize.width, fontSize.height
        );
        
        textField = UITextField(frame: textFieldRect)
        textField.backgroundColor = UIColor.clearColor()
        textField.textColor = UIColor(white: 1.0, alpha: 0.8)
        textField.textAlignment = .Center
        textField.font = UIFont(
            name: "Avenir",
            size: WZRotateSliderConfig.FontSize
            )!
        textField.text = "\(self.angle)"
    
        super.init(frame: frame)
        
        self.opaque = true
        self.radius = self.frame.size.width/2 - WZRotateSliderConfig.Padding
        addSubview(textField)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        //println("Touches Moved")
        
        if let touch = touches.first as? UITouch {
            var location = touch.locationInView(self)
            moveHandle(location)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //println("Touches Ended")
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        //println("Touches Cancelled")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let ctx = UIGraphicsGetCurrentContext()
        
        // Draw Mask
        CGContextAddArc(
            ctx,
            self.frame.size.width/2,
            self.frame.size.height/2,
            self.radius,
            0,
            2.0 * M_PI,
            0
        )
        UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).set()
        CGContextSetLineWidth(ctx, 72)
        CGContextSetLineCap(ctx, kCGLineCapButt)
        CGContextDrawPath(ctx, kCGPathStroke)
        
        // Gradient
        UIGraphicsBeginImageContext(self.bounds.size)
        let imgCTX = UIGraphicsGetCurrentContext()
        
        CGContextAddArc(
            imgCTX,
            CGFloat(self.bounds.size.width/2.0),
            CGFloat(self.bounds.size.height/2.0),
            self.radius, 0, CGFloat(2 * M_PI),
            0
        )
        
        UIColor.redColor().set()
        CGContextSetLineWidth(imgCTX, WZRotateSliderConfig.LineWidth)
        CGContextDrawPath(imgCTX, kCGPathStroke)
        
        var mask:CGImageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext())
        UIGraphicsEndImageContext();
        
        CGContextSaveGState(ctx)
        
        CGContextClipToMask(ctx, self.bounds, mask)
        let startColorComponents = CGColorGetComponents(startColor.CGColor)
        let endColorComponents = CGColorGetComponents(endColor.CGColor)
        let components = [
            startColorComponents[0], startColorComponents[1], startColorComponents[2], 1.0,
            endColorComponents[0], endColorComponents[1], endColorComponents[2], 1.0
        ]
        let gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), components, nil, 2)
        
        CGContextDrawLinearGradient(
            ctx,
            gradient,
            CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)),
            0
        );
        
        CGContextRestoreGState(ctx);
        
        drawHandle(ctx)
    }
    
    func drawHandle(ctx:CGContextRef){
        CGContextSaveGState(ctx);
    
        var handleCenter = convertPointFromAngle(angle)
        
        UIColor(white:1, alpha:0.7).set();
        
        let lineWidth = WZRotateSliderConfig.LineWidth
        CGContextFillEllipseInRect(
            ctx,
            CGRect(
                x: Double(handleCenter.x),
                y: Double(handleCenter.y),
                width: Double(lineWidth),
                height: Double(lineWidth)
            )
        );
        
        CGContextRestoreGState(ctx);
    }
    
    func moveHandle(lastPoint:CGPoint){
        let centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        let currentAngle:Double = computeAngle(centerPoint, p2: lastPoint);
        
        angle = 360 - Int(currentAngle)
        textField.text = "\(angle)"
        
        delegate?.sliderDidUpdateValue(self, value: angle)
        
        setNeedsDisplay()
    }
    
    func convertPointFromAngle(angle:Int)->CGPoint {
        let lineWidth = WZRotateSliderConfig.LineWidth
        let center = CGPoint(
            x: self.frame.size.width/2 - lineWidth/2,
            y: self.frame.size.height/2 - lineWidth/2
        )
        
        let y = round(radius * sin(toRadian(Double(angle)))) + Double(center.y)
        let x = round(radius * cos(toRadian(Double(angle)))) + Double(center.x)
    
        return CGPoint(x: x, y: y);
    }
    
    func computeAngle(p1:CGPoint , p2:CGPoint) -> Double {
        var delta = CGPoint(x: p2.x - p1.x, y: p1.y - p2.y)
        
        let radians = Double(atan2(delta.y, delta.x))
        let result = toDegree(radians)
        return result >= 0 ? result : result + 360
    }
}