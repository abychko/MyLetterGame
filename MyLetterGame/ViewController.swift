//
//  ViewController.swift
//  MyLetterGame
//
//  Created by Alexey Bychko on 25/02/2018.
//  Copyright © 2018 Alexey Bychko. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    

    @IBOutlet weak var AttemptsLeftLabel: UILabel!
    @IBOutlet var CardsCollection: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    
    var Letters: NSArray = ["A", "B", "C", "A", "B", "C"]
    var openCards: [UIButton] = []

    var attemptsLeft = 10 {
        didSet {
            AttemptsLeftLabel.text = "Попыток: " + String(attemptsLeft)
        }
    }
    
    func clearCardFound(button: UIButton){
        button.setTitle("", for: [])
        button.backgroundColor = .white
        button.isEnabled = false
        openCards = openCards.filter { $0 != button }
    }
    
    func closeCard(button: UIButton){
        button.setTitle("", for: [])
        button.backgroundColor = .green
        openCards = openCards.filter { $0 != button }
    }
    
    func endGame(win: Bool){
        var result = "Вы проиграли!"
        for _card in CardsCollection {
            _card.isEnabled = false
        }
        if win {
            result = "Вы победили!"
        }
        let alert = UIAlertController(title: result, message: "Игра окончена", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        newGameButton.isEnabled = true
    }
    
    func updateGameStatus(){
        let cardsLeft = CardsCollection.filter { $0.isEnabled == true }
        if attemptsLeft <= 0 && cardsLeft.count > 2 {
            endGame(win: false)
        }
        
        switch openCards.count {
        case 1:
            return
        case 2:
            if cardsLeft.count == 2 {
                if attemptsLeft >= 0 {
                    endGame(win: true)
                }
            }
            return
        case 3:
            if openCards[0].currentTitle == openCards[1].currentTitle {
                clearCardFound(button: openCards[0])
                clearCardFound(button: openCards[0])
            }else{
                closeCard(button: openCards[0])
                closeCard(button: openCards[0])
            }
            break
        default:
            return
        }
    }
    
    func startGame(){
        Letters = Letters.shuffled() as NSArray
        attemptsLeft = 10
        for _card in CardsCollection {
            _card.isEnabled = true
            _card.backgroundColor = .green
            _card.setTitle("", for: [])
            
            _card.layer.borderWidth = 2.0
            _card.layer.borderColor = UIColor.gray.cgColor
            _card.layer.cornerRadius = 20.0

        }
        openCards.removeAll()
        newGameButton.isEnabled = false
    }
    
    @IBAction func newGameAction(_ sender: UIButton) {
        startGame()
    }
    
    @IBAction func letterPressed(_ sender: UIButton) {
        
        if (sender.currentTitle?.isEmpty)! {
            openCards.append(sender)
            sender.backgroundColor = .white
            let _title = Letters[ CardsCollection.index(of: sender)! ]
            sender.setTitle(_title as? String, for: [])
            attemptsLeft -= 1
            updateGameStatus()
        }else{
            openCards = openCards.filter {$0 != sender }
            sender.backgroundColor = .green
            sender.setTitle("", for: [])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startGame()
        newGameButton.layer.borderWidth = 2.0
        newGameButton.layer.borderColor = UIColor.gray.cgColor
        newGameButton.layer.cornerRadius = 5.0
    }


    
}

