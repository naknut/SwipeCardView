//
//  CardContainer.swift
//  SwipeCardView
//
//  Created by Marcus Isaksson on 14/01/16.
//  Copyright © 2016 naknut. All rights reserved.
//

import UIKit

/// Protocol for handeling card swipeing
protocol CardContainerDataSource {
    /// This method should be called if a card 🃏 is swiped to the left
    func cardSwipedLeft(_ card: Card)
    ///This method should be called if a card 🃏 is swiped to the right
    func cardSwipedRight(_ card: Card)
}

/// This class contans a number of swipeable cards 🃏
class CardContainer: UIView, CardContainerDataSource {

    fileprivate let MAX_BUFFER_SIZE = 2
    fileprivate let CARD_HEIGHT: CGFloat = 386
    fileprivate let CARD_WIDTH: CGFloat = 290
    
    fileprivate var cardsLoadedIndex = 0
    fileprivate var cards = [Card]()
    
    fileprivate var checkButton = UIButton(frame: CGRect(x: 60, y: 550, width: 59, height: 59))
    fileprivate var xButton = UIButton(frame: CGRect(x: 200, y: 550, width: 59, height: 59))
    
    fileprivate var exampleCardLabels: [String]
    
    fileprivate var isLoaded = false
    
    override init(frame: CGRect) {
        exampleCardLabels = ["first", "second", "third", "fourth", "last"]
        super.init(frame: frame)
        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        exampleCardLabels = ["first", "second", "third", "fourth", "last"]
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!isLoaded) {
            self.loadCards()
        }
    }
    
    fileprivate func setupViews() {
        xButton.setImage(UIImage(named: "xButton"), for: UIControlState())
        checkButton.setImage(UIImage(named: "checkButton"), for: UIControlState())
        self.addSubview(xButton)
        self.addSubview(checkButton)
    }

    
    fileprivate func createCard(_ label: String) -> Card {
        let card = Card(frame: CGRect(x: (self.frame.width - CARD_WIDTH)/2, y: (self.frame.height - CARD_HEIGHT)/2, width: CARD_WIDTH, height: CARD_HEIGHT))
        card.text = label
        card.delegate = self
        return card
    }
    
    fileprivate func loadCards() {
        for label in exampleCardLabels {
            cards.append(createCard(label))
        }
        for i in 0 ..< cards.count {
            if(i == 0) {
                self.addSubview(cards[i])
            } else {
                self.insertSubview(cards[i], belowSubview: cards[i-1])
            }
        }
        self.isLoaded = true
    }
    
    // MARK: - CardContainerDataSource
    
    func cardSwipedLeft(_ card: Card) {
        let finishPoint = CGPoint(x: -500, y: 2.0 * card.yFromCenter + card.originalPoint.y)
        self.animateCardToPoint(card, finishPoint: finishPoint) { complete in
            card.removeFromSuperview()
            self.cards.removeFirst()
        }
        print("LEFT")
    }
    
    func cardSwipedRight(_ card: Card) {
        let finishPoint = CGPoint(x: 500, y: 2.0 * card.yFromCenter + card.originalPoint.y);
        self.animateCardToPoint(card, finishPoint: finishPoint) { complete in
            card.removeFromSuperview()
            self.cards.removeFirst()
        }
        print("RIGHT")
    }
    
    /**
    Animates a card do a specific location in the container
     */
    fileprivate func animateCardToPoint(_ card: Card, finishPoint: CGPoint, compleation: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            card.center = finishPoint
            }, completion: { (complete) -> Void in
                compleation(complete)
        }) 
    }
}
