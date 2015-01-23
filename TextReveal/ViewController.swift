//
//  ViewController.swift
//  TextReveal
//
//  Created by Oliver Foggin on 21/01/2015.
//  Copyright (c) 2015 Oliver Foggin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let quotes: [String] = [
        "When you are courting a nice girl an hour seems like a second.\n\nWhen you sit on a red-hot cinder a second seems like an hour.\n\nThat's relativity.",
        "You have to learn the rules of the game.\n\nAnd then you have to play better than anyone else.",
        "Learn from yesterday, live for today, hope for tomorrow.\n\nThe important thing is not to stop questioning.",
        "We cannot solve our problems with the same thinking we used when we created them.",
        "The true sign of intelligence is not knowledge but imagination.",
        "Whoever is careless with the truth in small matters cannot be trusted with important matters."
    ]
    
    @IBOutlet weak var revealTextView: OJFTextRevealView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        revealTextView.font = UIFont(name: "Menlo-Bold", size: 30)!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        displayRandomTextFromArray(quotes)
    }
    
    @IBAction func displayNewQuote() {
        displayRandomTextFromArray(quotes)
    }

    func displayRandomTextFromArray(array: [String]) {
        revealTextView.displayText(array[Int(arc4random_uniform(UInt32(quotes.count)))].uppercaseString)
    }
}

