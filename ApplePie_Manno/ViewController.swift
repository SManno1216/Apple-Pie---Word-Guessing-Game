//
//  ViewController.swift
//  ApplePie_Manno
//
//  Created by Steven  Manno on 10/6/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    var listOfWords = ["steven", "swift", "buccaneer", "bug",
    "program", "glorious"]
    
    let incorrectMovesAllowed = 7
    
    var totalWins = 0
    var totalLosses = 0
    
    var round = 1 {
        didSet{
            newRound()
        }
    }
    
    var currentGame: Game!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        newRound()
        
    }
    
    func newRound(){
        
        if !listOfWords.isEmpty{
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
            updateUI()
        }
        else{
           //showPlayAgainDialog()
            updateUI()
            enableLetterButtons(false)
        }
        
    }
    
    func enableLetterButtons(_ enable: Bool){
        for button in letterButtons{
            button.isEnabled = enable
        }
    }
    
    func updateUI(){
        
        var letters = [String]()
        
        for letter in currentGame.formattedWord{
            letters.append(String(letter))
        }
        
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        
        
        scoreLabel.text = "Wins: \(totalWins)  Losses: \(totalLosses)"
        
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
        
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        
        currentGame.playerGuessed(letter: letter)
        updateGameState()
        
    }
    
    func updateGameState(){
        
        if currentGame.incorrectMovesRemaining == 0{
            if listOfWords.isEmpty{
                updateUI()
                showPlayAgainDialog(win: false)
                totalLosses += 1
                //round += 1;
            }else{
                updateUI()
                showLossDialog()
                totalLosses += 1
                //round += 1;
            }
        }else if currentGame.word == currentGame.formattedWord{
            if listOfWords.isEmpty{
                updateUI()
                showPlayAgainDialog(win: true)
                totalWins += 1
            }else{
                updateUI()
                showWinDialog()
                totalWins += 1
            }
        }else{
            updateUI()
        }
    }
    
    func showWinDialog(){
        
        let dialogMessage = UIAlertController(title: "You Guessed Correctly!", message: "The word was: \(currentGame.word)", preferredStyle: .alert)
        
        let newRound = UIAlertAction(title: "Next Round", style: .default) { UIAlertAction in
            //self.totalWins += 1
            self.round += 1
        }
        
        dialogMessage.addAction(newRound)
        self.present(dialogMessage, animated: true, completion: nil)
            
    }
    
    func showLossDialog(){
        
        let dialogMessage = UIAlertController(title: "You Guessed Incorrectly!", message: "The word was: \(currentGame.word)", preferredStyle: .alert)
        
        
        let newRound = UIAlertAction(title: "Next Round", style: .default) { UIAlertAction in
            self.round += 1
           
        }
        dialogMessage.addAction(newRound)
        self.present(dialogMessage, animated: true, completion: nil)
            
        }
    
    func showPlayAgainDialog(win: Bool){
        
        var message: String
        
        if win{
            message = "You Guessed Correctly!"
        }else{
            message = "You Guessed Incorrectly!"
        }
        
        let dialogMessage = UIAlertController(title: "\(message)", message: "The word was: \(currentGame.word)", preferredStyle: .alert)
        
        let playAgain = UIAlertAction(title: "Play Again", style: .default) { UIAlertAction in
            
            self.listOfWords = ["steven", "swift", "buccaneer", "bug",
                           "program", "glorious"]
            
            self.totalWins = 0;
            self.totalLosses = 0;
            self.updateUI()
            self.round = 1
            
        }
        
        let endGame = UIAlertAction(title: "End Game", style: .default) { UIAlertAction in
            self.enableLetterButtons(false)
        }
        
        
        dialogMessage.addAction(playAgain)
        dialogMessage.addAction(endGame)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}

