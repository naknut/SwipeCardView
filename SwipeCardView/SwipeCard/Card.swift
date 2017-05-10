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
    
    fileprivate let ACTION_MARGIN: CGFloat = 120
    fileprivate let SCALE_STRENGTH: CGFloat = 4.0
    fileprivate let SCALE_MAX: CGFloat = 0.93
    fileprivate let ROTATION_MAX: CGFloat = 1.0
    fileprivate let ROTATION_STRENGTH: CGFloat = 320.0
    fileprivate let ROTATION_ANGLE = CGFloat(.pi/8.0)
    
    ///How far from the center the card is on the X axis.
    fileprivate(set) var xFromCenter: CGFloat = 0.0
    ///How far from the center the card is on the Y axis.
    fileprivate(set) var yFromCenter: CGFloat = 0.0
    ///Read only property that should be set to the point where the card was when created.
    fileprivate(set) var originalPoint = CGPoint()
    
    /// The delegate that will be called back when the card 🃏 finishes a swipe.
    var delegate: CardContainerDataSource?
    
    ///The text to be displayed on the card 🃏
    var text: String?
    fileprivate var information: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override func layoutSubviews() {
        self.information = UILabel(frame: CGRect(x: 0, y: 50, width: self.frame.size.width, height: 100))
        self.information!.textAlignment = NSTextAlignment.center
        self.information!.text = self.text
        self.addSubview(self.information!)
    }

    fileprivate func setupView() {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSize(width: 1, height: 1);
        self.backgroundColor = UIColor.white
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(Card.beingDragged)))
    }
    
    fileprivate func afterSwipeAction() {
        if (xFromCenter > ACTION_MARGIN) {
            if let dataSource = self.delegate {
                dataSource.cardSwipedRight(self)
            }
        } else if (xFromCenter < -ACTION_MARGIN) {
            if let dataSource = self.delegate {
                dataSource.cardSwipedLeft(self)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            }) 
        }
    }
    
    @objc fileprivate func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        xFromCenter = gestureRecognizer.translation(in: self).x
        yFromCenter = gestureRecognizer.translation(in: self).y
        
        switch (gestureRecognizer.state) {
        case UIGestureRecognizerState.began:
            self.originalPoint = self.center
            break
        case UIGestureRecognizerState.changed:
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngel = ROTATION_ANGLE * rotationStrength
            let scale = max(1.0 - CGFloat(fabsf(Float(rotationStrength))) / SCALE_STRENGTH, SCALE_MAX)
            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
            let transform = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            break
        case UIGestureRecognizerState.ended:
            self.afterSwipeAction()
            break
        default:
            break
        }
    }
}
