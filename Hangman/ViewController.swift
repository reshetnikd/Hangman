//
//  ViewController.swift
//  Hangman
//
//  Created by Dmitry Reshetnik on 21.03.2020.
//  Copyright © 2020 Dmitry Reshetnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var levelLabel: UILabel!
    var wordLabel: UILabel!
    var alphabetButtons = [UIButton]()
    
    var allWords = [String]()
    
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var word = ""
    var answers = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.textAlignment = .left
        levelLabel.text = "Level: 1"
        view.addSubview(levelLabel)
        
        wordLabel = UILabel()
        wordLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.font = UIFont.systemFont(ofSize: 72)
        wordLabel.textAlignment = .center
        wordLabel.numberOfLines = 1
        view.addSubview(wordLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.cornerRadius = 8
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40),
            wordLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8, constant: -20),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 476),
            buttonsView.heightAnchor.constraint(equalToConstant: 80),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        // set some values for the width and height of each button
        let width = 36
        let height = 36
        
        // create 26 buttons as a 2x13 grid
        for row in 0..<2 {
            for col in 0..<13 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                // give the button leter text from alphabet
                letterButton.setTitle(alphabet[row != 1 ? col : col + 13], for: .normal)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to our alphabetButtons array
                alphabetButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        for (index, letter) in word.enumerated() {
            if letter.uppercased() == sender.titleLabel?.text {
                wordLabel.text = replace(inString: wordLabel.text!, at: index, with: Character(sender.titleLabel!.text!))
                score += 1
            }
        }
        answers += 1
        
        if answers == 7 {
            let ac = UIAlertController(title: "Lose", message: "You are lose, try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            loadLevel()
        }
        
        if (wordLabel.text?.contains("_"))! {
            return
        } else {
            let ac = UIAlertController(title: "Win", message: "You are win, move to the next level.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            level += 1
            loadLevel()
        }
    }
    
    func loadLevel() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
                word = allWords.randomElement()!
            }
        }

        var labelText = ""

        for _ in word {
            labelText.append("_")
        }
        
        wordLabel.text = labelText
        answers = 0
    }
    
    func replace(inString: String, at index: Int, with newChar: Character) -> String {
        var chars = Array(inString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }


}

