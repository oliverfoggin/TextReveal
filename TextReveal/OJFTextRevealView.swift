//
//  OJFTextRevealView.swift
//  TextReveal
//
//  Created by Oliver Foggin on 22/01/2015.
//  Copyright (c) 2015 Oliver Foggin. All rights reserved.
//

import UIKit

@IBDesignable class OJFTextRevealView: UIView {

    private let revealLabel1 = UILabel()
    private let revealLabel2 = UILabel()
    
    private var currentLabel:UILabel!
    
    var font: UIFont = .systemFontOfSize(21)
    @IBInspectable var color: UIColor = .blackColor()
    @IBInspectable var fadeDuration: Double = 0.4
    @IBInspectable var fadeDelay: Double = 0.4

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    private func setupView() -> Void {
        self.backgroundColor = .clearColor()
        
        revealLabel1.textAlignment = .Center
        revealLabel2.textAlignment = .Center
        
        revealLabel1.numberOfLines = 0
        revealLabel2.numberOfLines = 0
        
        addSubview(revealLabel1)
        addSubview(revealLabel2)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        revealLabel1.frame = bounds
        revealLabel2.frame = bounds
    }

    override func prepareForInterfaceBuilder() {
        revealLabel1.text = "Hello, world!"
        revealLabel1.textColor = color
        revealLabel1.font = .systemFontOfSize(21)
        revealLabel1.textAlignment = .Center
        revealLabel1.numberOfLines = 0
    }
    
    func displayText(newText: String) -> Void {
        revealLabel1.attributedText = NSMutableAttributedString(string: newText, attributes: [NSForegroundColorAttributeName: UIColor.clearColor(),
            NSFontAttributeName: font])
        currentLabel = revealLabel1
        
        let letterRanges = self.letterRangeDictionaryFromText(self.revealLabel1.attributedText.string as NSString)
        
        let rangesArray: [[NSRange]] = self.shuffle([[NSRange]](letterRanges.values))
        
        let attributedTextArray = self.attributedTextArrayFromRanges(rangesArray, baseAttributedString: self.revealLabel1.attributedText)
        
        self.animateTextAtIndex(0, fromArray: attributedTextArray, duration: self.fadeDuration, delay: self.fadeDelay)
    }
    
    private func letterRangeDictionaryFromText(text: NSString) -> [String : [NSRange]] {
        var letterRanges: [String : [NSRange]] = [:]
        let whiteSpaces: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        text.enumerateSubstringsInRange(NSMakeRange(0, text.length),
            options: NSStringEnumerationOptions.ByComposedCharacterSequences) {
                (substring, substringRange, enclosingRange, stop) -> () in
                
                if let range = substring.rangeOfCharacterFromSet(whiteSpaces, options: nil, range: nil) {
                    return
                }
                
                var rangeArray: [NSRange]
                
                if (letterRanges[substring] == nil) {
                    rangeArray = []
                } else {
                    rangeArray = letterRanges[substring]!
                }
                
                rangeArray.append(substringRange)
                
                letterRanges[substring] = rangeArray
        }
        
        return letterRanges
    }
    
    private func attributedTextArrayFromRanges(rangesArray: [[NSRange]], baseAttributedString: NSAttributedString) -> [NSAttributedString] {
        var attributedTextArray: [NSAttributedString] = []
        var attributedText = NSMutableAttributedString(attributedString: baseAttributedString)
        
        for ranges in rangesArray {
            attributedText = NSMutableAttributedString(attributedString: attributedText)
            
            for range in ranges {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: self.color, range: range)
            }
            
            attributedTextArray.append(attributedText)
        }
        
        return attributedTextArray
    }
    
    private func animateTextAtIndex(index: Int, fromArray array: [NSAttributedString], duration: Double, delay: Double) -> Void {
        if index >= array.count {
            return
        }
        
        var nextLabel: UILabel!
        
        if (currentLabel == revealLabel1) {
            nextLabel = revealLabel2
        } else {
            nextLabel = revealLabel1
        }
        
        nextLabel.attributedText = array[index]
        
        UIView.animateWithDuration(
            duration,
            delay: delay,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                () -> Void in
                nextLabel.alpha = 1.0
            })
            {
                (finished) -> Void in
                self.currentLabel.alpha = 0.0
                self.currentLabel = nextLabel
                self.animateTextAtIndex(index + 1, fromArray: array, duration: duration * 0.9, delay: delay * 0.9)
        }
    }
    
    private func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let count = countElements(list)
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}
