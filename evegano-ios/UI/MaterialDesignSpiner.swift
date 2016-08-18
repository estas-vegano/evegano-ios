//
//  MaterialDesignSpiner.swift
//  evegano-ios
//
//  Created by alexander on 12.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class MaterialDesignSpiner: UIView {
    //MARK: public varibales
    var duration: NSTimeInterval = 1.5
    var lineWidth: CGFloat = 4.0
    
    //MARK: private
    private struct ConstantKeys {
        static let strokeStartKey = "strokeStart"
        static let strokeEndKey = "strokeEnd"
        static let transformKey = "transform.rotation"
        static let animationRotationKey = "materialdesignspiner.rotation"
        static let animationStrokeKey = "materialdesignspiner.stroke"
    }
    
    private let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    private var isAnimating = false
    
    private lazy var progressLayer: CAShapeLayer = self.initProgressLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.layer.addSublayer(self.progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        updatePath()
    }
    
    private func initProgressLayer() -> CAShapeLayer {
        let progressLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor.whiteColor().CGColor
        progressLayer.fillColor = nil
        progressLayer.lineWidth = self.lineWidth
        return progressLayer
    }
    
    func startAnimating() {
        if self.isAnimating {
            return
        }
        
        let animation = CABasicAnimation()
        animation.keyPath = ConstantKeys.transformKey
        animation.duration = self.duration / 0.375
        animation.fromValue = 0.0
        animation.toValue = 2 * M_PI
        animation.repeatCount = Float.infinity
        animation.removedOnCompletion = false
        self.progressLayer.addAnimation(animation, forKey: ConstantKeys.animationRotationKey)
        
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = ConstantKeys.strokeStartKey
        headAnimation.duration = self.duration / 1.5
        headAnimation.fromValue = 0.0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction
        
        let tailAnimation  = CABasicAnimation()
        tailAnimation.keyPath = ConstantKeys.strokeEndKey
        tailAnimation.duration = self.duration / 1.5
        tailAnimation.fromValue = 0.0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = self.timingFunction
        
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = ConstantKeys.strokeStartKey
        endHeadAnimation.beginTime = 1.5 / 1.5
        endHeadAnimation.duration = self.duration / 3.0
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = self.timingFunction
        
        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = ConstantKeys.strokeEndKey
        endTailAnimation.beginTime = 1.5 / 1.5
        endTailAnimation.duration = self.duration / 3.0
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = self.timingFunction
        
        let animations = CAAnimationGroup()
        animations.duration = self.duration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity
        animations.removedOnCompletion = false;
        self.progressLayer.addAnimation(animations, forKey: ConstantKeys.animationStrokeKey)
        
        self.isAnimating = true
    }
    
    func stopAnimating() {
        if !self.isAnimating {
            return
        }
        self.progressLayer.removeAnimationForKey(ConstantKeys.animationRotationKey)
        self.progressLayer.removeAnimationForKey(ConstantKeys.animationStrokeKey)
        
        self.isAnimating = false
    }
    
    private func updatePath() {
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        let radius: CGFloat = CGRectGetHeight(self.bounds) / 2 - 1.5 / 2;
        let startAngle: CGFloat = 0.0;
        let endAngle: CGFloat = (CGFloat)(2.0*M_PI);
        let path: UIBezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.progressLayer.path = path.CGPath;
    
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = 0.0
    }
}
