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
    // keep track of all the tapped buttons
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    // use property observer to update scoreLabel; note score type must be explicit
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
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
        // search for currentAnswer in the solutions array
        if let index = solutions.indexOf(currentAnswer.text!) {
            activatedButtons.removeAll()
            // collect all the answers ("7 letters", "8 letters", etc) into an array of strings
            var answers = answersLabel.text!.componentsSeparatedByString("\n")
            // replace the answer at index with currentAnswer
            answers[index] = currentAnswer.text!
            // join all strings in the answers array back into one long string, then display it in answersLabel
            answersLabel.text = answers.joinWithSeparator("\n")
            currentAnswer.text = ""
            // update score
            score += 1
            // all 7 words are solved: prompt user to go to the next level
            if score % 7 == 0 {
                let message = "Are you ready for the next level?"
                let alertController = UIAlertController(title: "Well done!", message: message, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func clearTapped(sender: AnyObject) {
        // remove the text from the current answer text field
        currentAnswer.text = ""
        for button in activatedButtons {
            // activate (unhide) all tapped buttons
            // button.hidden = false
            let animations = {
                button.alpha = 1
            }
            let completion = { (finished: Bool) in
            }
            UIView.animateWithDuration(1, delay: 0, options: [], animations: animations, completion: completion)
        }
        // remove all tapped buttons from activatedButtons
        activatedButtons.removeAll()
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
                    clueString += "\(index + 1). \(clue)\n"
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

    func letterTapped(button: UIButton) {
        // obtain the title label of the tapped button and append it to the current answer text field
        currentAnswer.text = currentAnswer.text! + button.titleLabel!.text!
        // save the button in activatedButtons array
        activatedButtons.append(button)
        // disable the button
        // button.hidden = true
        let animations = {
            button.alpha = 0
        }
        let completion = { (finished: Bool) in
        }
        UIView.animateWithDuration(1, delay: 0, options: [], animations: animations, completion: completion)
    }

    func levelUp(action: UIAlertAction!) {
        level += 1
        // clear out solutions array to prepare it for the next level
        solutions.removeAll(keepCapacity: true)
        // go up one level
        loadLevel()
        // activate all letterButtons
        for button in letterButtons {
            // button.hidden = false
            let animations = {
                button.alpha = 1
            }
            let completion = { (finished: Bool) in
            }
            UIView.animateWithDuration(1, delay: 0, options: [], animations: animations, completion: completion)
        }
    }
}

