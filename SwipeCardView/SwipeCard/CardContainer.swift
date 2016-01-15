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
    func cardSwipedLeft(card: Card)
    ///This method should be called if a card 🃏 is swiped to the right
    func cardSwipedRight(card: Card)
}

/// This class contans a number of swipeable cards 🃏
class CardContainer: UIView, CardContainerDataSource {

    private let MAX_BUFFER_SIZE = 2
    private let CARD_HEIGHT: CGFloat = 386
    private let CARD_WIDTH: CGFloat = 290
    
    private var cardsLoadedIndex = 0
    private var cards = [Card]()
    
    private var checkButton = UIButton(frame: CGRectMake(60, 550, 59, 59))
    private var xButton = UIButton(frame: CGRectMake(200, 550, 59, 59))
    
    private var exampleCardLabels: [String]
    
    private var isLoaded = false
    
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
    
    private func setupViews() {
        xButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        checkButton.setImage(UIImage(named: "checkButton"), forState: UIControlState.Normal)
        self.addSubview(xButton)
        self.addSubview(checkButton)
    }

    
    private func createCard(label: String) -> Card {
        let card = Card(frame: CGRectMake((self.frame.width - CARD_WIDTH)/2, (self.frame.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT))
        card.text = label
        card.delegate = self
        return card
    }
    
    private func loadCards() {
        for label in exampleCardLabels {
            cards.append(createCard(label))
        }
        for (var i = 0; i < cards.count; i++){
            if(i == 0) {
                self.addSubview(cards[i])
            } else {
                self.insertSubview(cards[i], belowSubview: cards[i-1])
            }
        }
        self.isLoaded = true
    }
    
    // MARK: - CardContainerDataSource
    
    func cardSwipedLeft(card: Card) {
        let finishPoint = CGPointMake(-500, 2.0 * card.yFromCenter + card.originalPoint.y)
        self.animateCardToPoint(card, finishPoint: finishPoint) { complete in
            card.removeFromSuperview()
            self.cards.removeFirst()
        }
        print("LEFT")
    }
    
    func cardSwipedRight(card: Card) {
        let finishPoint = CGPointMake(500, 2.0 * card.yFromCenter + card.originalPoint.y);
        self.animateCardToPoint(card, finishPoint: finishPoint) { complete in
            card.removeFromSuperview()
            self.cards.removeFirst()
        }
        print("RIGHT")
    }
    
    /**
    Animates a card do a specific location in the container
     */
    private func animateCardToPoint(card: Card, finishPoint: CGPoint, compleation: (Bool) -> Void) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            card.center = finishPoint
            }) { (complete) -> Void in
                compleation(complete)
        }
    }
}
