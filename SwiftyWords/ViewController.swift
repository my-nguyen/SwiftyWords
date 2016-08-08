//
//  ViewController.swift
//  SwiftyWords
//
//  Created by My Nguyen on 8/8/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clues: UILabel!
    @IBOutlet weak var answers: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var score: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submit(sender: AnyObject) {
    }

    @IBAction func clear(sender: AnyObject) {
    }
}

