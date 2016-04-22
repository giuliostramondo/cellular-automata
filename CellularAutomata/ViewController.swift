//
//  ViewController.swift
//  CellularAutomata
//
//  Created by Giulio Stramondo on 21/04/16.
//  Copyright © 2016 ArancinoProject. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var ComboAutomaType: NSPopUpButton!
    //@IBOutlet weak var ComboAutomaType: NSComboBox!
    
    @IBOutlet weak var RuleField: NSTextField!
    
    @IBOutlet weak var ImageField: NSImageView!
    
    var AutomaRow: [Bool] = []
    var tmpAutomaRow: [Bool] = []
    
    var BinaryRule:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmpAutoma = NSImage(size: NSSize(width: 1000, height: 733))
        tmpAutoma.lockFocus()
        NSColor.whiteColor().set()
        NSRectFill(NSMakeRect(0, 0, 1000, 733))
        tmpAutoma.unlockFocus()
        ImageField.image = tmpAutoma
        ComboAutomaType.removeAllItems()
        ComboAutomaType.addItemsWithTitles(["1D-Rule 2-Colors","1D-Rule 3-Colors"])

        for _ in 0...499 {
            AutomaRow.append(false)
        }
    }

    func drawRow(RowToDraw: [Bool], RowNumber: Int){
        if(RowNumber * 2 > 733){ return }
        for i in 0...498{
            if(RowToDraw[i]){
                NSColor.blackColor().set()
                NSRectFill(NSMakeRect(CGFloat(i*2), CGFloat(730-(2*RowNumber)), 2, 2))
            }
        }
    }
    
    func computeNextRow(CurrentRow: [Bool], RuleSet: [Bool])->[Bool]{
        var newRow: [Bool] = []
        newRow.append(false)
        for i in 1...498 {
            if(CurrentRow[i-1] && CurrentRow[i] && CurrentRow[i+1]){
                newRow.append(RuleSet[7])
                continue
            }
            if(CurrentRow[i-1] && CurrentRow[i] && !CurrentRow[i+1]){
                newRow.append(RuleSet[6])
                continue
            }
            if(CurrentRow[i-1] && !CurrentRow[i] && CurrentRow[i+1]){
                newRow.append(RuleSet[5])
                continue
            }
            if(CurrentRow[i-1] && !CurrentRow[i] && !CurrentRow[i+1]){
                newRow.append(RuleSet[4])
                continue
            }
            if(!CurrentRow[i-1] && CurrentRow[i] && CurrentRow[i+1]){
                newRow.append(RuleSet[3])
                continue
            }
            if(!CurrentRow[i-1] && CurrentRow[i] && !CurrentRow[i+1]){
                newRow.append(RuleSet[2])
                continue
            }
            if(!CurrentRow[i-1] && !CurrentRow[i] && CurrentRow[i+1]){
                newRow.append(RuleSet[1])
                continue
            }
            if(!CurrentRow[i-1] && !CurrentRow[i] && !CurrentRow[i+1]){
                newRow.append(RuleSet[0])
                continue
            }
        }
        newRow.append(false)
        return newRow
    }

    func getRuleSet(RuleName: Int)->[Bool]{
        var tmpRuleName = RuleName
        var tmpRuleArray:[Bool] = []
        var i=0
        while(tmpRuleName > 0){
            tmpRuleArray.append(tmpRuleName%2 == 1)
            tmpRuleName/=2
            i++
        }
        while i<8{
            tmpRuleArray.append(false)
            i++
        }
        return tmpRuleArray
    }
    @IBAction func runSimulation(sender: AnyObject) {
        var Rule: [Bool] = []
        if(self.ComboAutomaType.selectedItem?.title == "1D-Rule 2-Colors"){
            if self.RuleField.integerValue < 255 {
                Rule = getRuleSet(self.RuleField.integerValue)
                
                print(Rule)
                for i in 0...499 {
                    if (i==250){
                        AutomaRow[i]=true
                    }else{
                        AutomaRow[i]=false
                    }
                }
                
                let newAutoma = NSImage(size: NSSize(width: 1000, height: 733))
                newAutoma.lockFocus()
                NSColor.whiteColor().set()
                NSRectFill(NSMakeRect(0, 0, 1000, 733))
                drawRow(AutomaRow,RowNumber: 0)
                for i in 1...366{
                    tmpAutomaRow = computeNextRow(AutomaRow,RuleSet: Rule)
                    drawRow(tmpAutomaRow, RowNumber: i)
                    AutomaRow=tmpAutomaRow
                }
                //NSColor.blackColor().set()
                //NSRectFill(NSMakeRect(500, 723, 2, 2))
                newAutoma.unlockFocus()
                ImageField.image=newAutoma
            }
        }

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

