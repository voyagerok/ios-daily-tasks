//
//  CheckTaskButton.swift
//  ios-daily-tasks
//
//  Created by Николай on 03.02.17.
//  Copyright © 2017 Николай. All rights reserved.
//

import UIKit

class CheckTaskButton: UIButton {

//    var checkMarkBackgroundPadding : CGFloat = 0
    var checkBoxSideLength : CGFloat = 0
    
    var checkMarkBackgroundLayer : CAShapeLayer!
    var checkMarkLayer : CAShapeLayer!
    var checkMarkBackgroundPath : CGMutablePath!
    var checkMarkPath : UIBezierPath!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.checkMarkBackgroundLayer = CAShapeLayer()
        checkMarkBackgroundLayer.strokeColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        checkMarkBackgroundLayer.fillColor = UIColor.clear.cgColor
        checkMarkBackgroundLayer.lineWidth = 0.5
        self.layer.addSublayer(checkMarkBackgroundLayer)
        
        checkMarkLayer = CAShapeLayer()
        checkMarkLayer.strokeColor = UIColor.green.cgColor
        checkMarkLayer.fillColor = UIColor.clear.cgColor
        checkMarkLayer.lineWidth = 2
        checkMarkLayer.lineJoin = kCALineJoinRound
        self.layer.addSublayer(checkMarkLayer)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        checkBoxSideLength = bounds.width > bounds.height ? bounds.height : bounds.width;
        checkBoxSideLength *= 0.5
        
        drawCheckMarkBackground()
        drawCheckMark()
        
        checkMarkBackgroundLayer.path = checkMarkBackgroundPath
        if isSelected {
            checkMarkLayer.path = checkMarkPath.cgPath
            animateCheckMarkPath()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkMarkBackgroundLayer.path = checkMarkBackgroundPath
            if isSelected {
                checkMarkLayer.path = checkMarkPath?.cgPath
                animateCheckMarkPath()
            } else {
                checkMarkLayer.path = nil
            }
        }
    }
    
    func drawCheckMarkBackground() {
        checkMarkBackgroundPath = CGMutablePath()
        checkMarkBackgroundPath.addRect(CGRect(x: bounds.midX - checkBoxSideLength / 2,
                                               y: bounds.midY - checkBoxSideLength / 2,
                                               width: checkBoxSideLength,
                                               height: checkBoxSideLength))
        
//        checkMarkBackgroundLayer.path = checkMarkBackgroundPath
    }
    
    func drawCheckMark() {
        checkMarkPath = UIBezierPath()
        
        checkMarkPath.move(to: CGPoint(x: bounds.midX - checkBoxSideLength / 2,
                                       y: bounds.midY))
        checkMarkPath.addLine(to: CGPoint(x: bounds.midX,
                                          y: bounds.midY + checkBoxSideLength / 2))
        let firstPoint = CGPoint(x: bounds.midX,
                                 y: bounds.midY + checkBoxSideLength / 2)
        let secondPoint = CGPoint(x: bounds.midX + checkBoxSideLength / 2,
                                  y: bounds.midY - checkBoxSideLength / 2)
        let y = secondPoint.y - checkBoxSideLength / 4
        let x = calcX(firstPoint: firstPoint, secondPoint: secondPoint, yValue: y)
        print("x value is \(x)")
        checkMarkPath.addLine(to: CGPoint(x: x,
                                          y: y))
//        checkMarkPath.move(to: CGPoint(x: checkMarkBackgroundPadding * 2,
//                                       y: checkMarkBackgroundPadding * 4))
//        checkMarkPath.addLine(to: CGPoint(x: self.bounds.width / 2,
//                                          y: self.bounds.height - checkMarkBackgroundPadding * 2))
//        checkMarkPath.addLine(to: CGPoint(x: self.bounds.width - checkMarkBackgroundPadding * 2,
//                                          y: checkMarkBackgroundPadding * 2))
//        checkMarkLayer.path = checkMarkPath.cgPath
//        
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0.0
//        animation.toValue = 1.0
//        checkMarkLayer.add(animation, forKey: "strokeEnd")
    }
    
    func calcX(firstPoint: CGPoint, secondPoint: CGPoint, yValue: CGFloat) -> CGFloat {
        let k = (secondPoint.y - firstPoint.y) / (secondPoint.x - firstPoint.x)
        return (yValue - firstPoint.y) / k + firstPoint.x;
    }
    
    func animateCheckMarkPath() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.5
        checkMarkLayer.add(animation, forKey: "strokeEnd")
    }
}
