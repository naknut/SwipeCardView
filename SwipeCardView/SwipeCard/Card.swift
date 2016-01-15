//
//  Card.swift
//  SwipeCardView
//
//  Created by Marcus Isaksson on 14/01/16.
//  Copyright © 2016 naknut. All rights reserved.
//

import UIKit

/// The card 🃏 class used by CardContainer for the card views that can be dragged
class Card: UIView {
    
    private let ACTION_MARGIN: CGFloat = 120
    private let SCALE_STRENGTH: CGFloat = 4.0
    private let SCALE_MAX: CGFloat = 0.93
    private let ROTATION_MAX: CGFloat = 1.0
    private let ROTATION_STRENGTH: CGFloat = 320.0
    private let ROTATION_ANGLE = CGFloat(M_PI/8.0)
    
    ///How far from the center the card is on the X axis.
    private(set) var xFromCenter: CGFloat = 0.0
    ///How far from the center the card is on the Y axis.
    private(set) var yFromCenter: CGFloat = 0.0
    ///Read only property that should be set to the point where the card was when created.
    private(set) var originalPoint = CGPoint()
    
    /// The delegate that will be called back when the card 🃏 finishes a swipe.
    var delegate: CardContainerDataSource?
    
    ///The text to be displayed on the card 🃏
    var text: String?
    private var information: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override func layoutSubviews() {
        self.information = UILabel(frame: CGRectMake(0, 50, self.frame.size.width, 100))
        self.information!.textAlignment = NSTextAlignment.Center
        self.information!.text = self.text
        self.addSubview(self.information!)
    }

    private func setupView() {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.backgroundColor = UIColor.whiteColor()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "beingDragged:"))
    }
    
    private func afterSwipeAction() {
        if (xFromCenter > ACTION_MARGIN) {
            if let dataSource = self.delegate {
                dataSource.cardSwipedRight(self)
            }
        } else if (xFromCenter < -ACTION_MARGIN) {
            if let dataSource = self.delegate {
                dataSource.cardSwipedLeft(self)
            }
        } else {
            UIView.animateWithDuration(0.3) {
                self.center = self.originalPoint
                self.transform = CGAffineTransformMakeRotation(0)
            }
        }
    }
    
    private func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        xFromCenter = gestureRecognizer.translationInView(self).x
        yFromCenter = gestureRecognizer.translationInView(self).y
        
        switch (gestureRecognizer.state) {
        case UIGestureRecognizerState.Began:
            self.originalPoint = self.center
            break
        case UIGestureRecognizerState.Changed:
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngel = ROTATION_ANGLE * rotationStrength
            let scale = max(1.0 - CGFloat(fabsf(Float(rotationStrength))) / SCALE_STRENGTH, SCALE_MAX)
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter)
            let transform = CGAffineTransformMakeRotation(rotationAngel)
            let scaleTransform = CGAffineTransformScale(transform, scale, scale)
            self.transform = scaleTransform
            break
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction()
            break
        default:
            break
        }
    }
}
