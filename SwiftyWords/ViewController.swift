//
//  ViewController.swift
//  SwiftyWords
//
//  Created by My Nguyen on 8/8/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0
    var level = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // view.subviews is an array containing all the UIView's that are currently placed in our view controller,
        // which is all the buttons and labels, plus the text field
        // this is an enhanced for loop that adds a where condition so that the only items inside the loop
        // are subviews with that tag.
        for subview in view.subviews where subview.tag == 1001 {
            // cast the subview to a UIButton
            let button = subview as! UIButton
            letterButtons.append(button)
            // addTarget() is equivalent to Ctrl-drag a button in the storyboard to attach a method to a button click.
            button.addTarget(self, action: #selector(letterTapped), forControlEvents: .TouchUpInside)
        }

        loadLevel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitTapped(sender: AnyObject) {
    }

    @IBAction func clearTapped(sender: AnyObject) {
    }

    func loadLevel() {
        // all clues in this level
        var clueString = ""
        // number of letters in each answer
        var solutionString = ""
        // all letter groups: HA, UNT, ED, etc
        var letterBits = [String]()

        // get the path of file "level1.txt"
        if let file = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt") {
            // read the file contents
            if let contents = try? String(contentsOfFile: file, usedEncoding: nil) {
                // convert contents into an array of lines
                var lines = contents.componentsSeparatedByString("\n")
                // shuffle the lines array
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(lines) as! [String]
                // loop through each item in lines
                for (index, line) in lines.enumerate() {
                    // example of a line: HA|UNT|ED: Ghosts in residence
                    // split the line based on separator ": "
                    let parts = line.componentsSeparatedByString(": ")
                    // answer contains "HA|UNT|ED"
                    let answer = parts[0]
                    // clue contains "Ghosts in residence"
                    let clue = parts[1]
                    // clueString contains "1. Ghosts in residence"
                    clueString += "\(index + 1). \(clue)"
                    // convert "HA|UNT|ED" to "HAUNTED"
                    let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "")
                    // solutionString contains "7 letters\n"
                    solutionString += "\(solutionWord.characters.count) letters\n"
                    solutions.append(solutionWord)
                    // convert "HA|UNT|ED" to ["HA", "UNT", "ED"]
                    let bits = answer.componentsSeparatedByString("|")
                    letterBits += bits
                }
            }
        }

        cluesLabel.text = clueString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        answersLabel.text = solutionString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterBits) as! [String]
        letterButtons = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterButtons) as! [UIButton]
        if letterBits.count == letterButtons.count {
            // loop from 0 up to but not including letterBits.count
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], forState: .Normal)
            }
        }
    }
}

