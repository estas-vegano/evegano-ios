//
//  MaterialDesignSpiner.swift
//  evegano-ios
//
//  Created by alexander on 12.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class MaterialDesignSpiner: UIView {
    //constants
    let kStrokeStartKey: String = "strokeStart"
    let kStrokeEndKey: String = "strokeEnd"
    let kTransformKey: String = "transform.rotation"
    let kAnimationRotationKey: String = "materialdesignspiner.rotation"
    let kAnimationStrokeKey: String = "materialdesignspiner.stroke"
    
    let timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    //varibales
    var duration: NSTimeInterval = 1.5
    var lineWidth: CGFloat = 2
    var isAnimating: Bool = false
    
    lazy var progressLayer: CAShapeLayer = self.initProgressLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.layer.addSublayer(self.progressLayer)
    }
    
    func initProgressLayer() -> CAShapeLayer {
        let progressLayer: CAShapeLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor.whiteColor().CGColor
        progressLayer.fillColor = nil
        progressLayer.lineWidth = self.lineWidth
        return progressLayer
    }
    
    func startAnimating() {
        if self.isAnimating {
            return
        }
        
        let animation: CABasicAnimation = CABasicAnimation()
        animation.keyPath = kTransformKey
        animation.duration = self.duration / 0.375
        animation.fromValue = 0.0
        animation.toValue = 2 * M_PI
        animation.repeatCount = Float.infinity
        animation.removedOnCompletion = false
        self.progressLayer.addAnimation(animation, forKey: kAnimationRotationKey)
        
        let headAnimation: CABasicAnimation = CABasicAnimation()
        headAnimation.keyPath = kStrokeStartKey
        headAnimation.duration = self.duration / 1.5
        headAnimation.fromValue = 0.0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction
        
        let tailAnimation: CABasicAnimation  = CABasicAnimation()
        tailAnimation.keyPath = kStrokeEndKey
        tailAnimation.duration = self.duration / 1.5
        tailAnimation.fromValue = 0.0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = self.timingFunction
        
        let endHeadAnimation: CABasicAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = kStrokeStartKey
        endHeadAnimation.beginTime = 1.5 / 1.5
        endHeadAnimation.duration = self.duration / 3.0
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = self.timingFunction
        
        let endTailAnimation: CABasicAnimation = CABasicAnimation()
        endTailAnimation.keyPath = kStrokeEndKey
        endTailAnimation.beginTime = 1.5 / 1.5
        endTailAnimation.duration = self.duration / 3.0
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = self.timingFunction
        
        let animations: CAAnimationGroup = CAAnimationGroup()
        animations.duration = self.duration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity
        animations.removedOnCompletion = false;
        self.progressLayer.addAnimation(animations, forKey: kAnimationStrokeKey)
        
        self.isAnimating = true
    }
    
    func stopAnimating() {
        if !self.isAnimating {
            return
        }
        self.progressLayer.removeAnimationForKey(kAnimationRotationKey)
        self.progressLayer.removeAnimationForKey(kAnimationStrokeKey)
        
        self.isAnimating = false
    }
    
    func updatePath() {
        let center: CGPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        let radius: CGFloat = CGRectGetHeight(self.bounds) / 2 - 1.5 / 2;
        let startAngle: CGFloat = 0.0;
        let endAngle: CGFloat = (CGFloat)(2.0*M_PI);
        let path: UIBezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.progressLayer.path = path.CGPath;
    
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = 0.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        updatePath()
    }
    
}
