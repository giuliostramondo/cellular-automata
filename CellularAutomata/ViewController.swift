//
//  ViewController.swift
//  CellularAutomata
//
//  Created by Giulio Stramondo on 21/04/16.
//  Copyright © 2016 Giulio Stramondo. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController {

    @IBOutlet weak var ComboAutomaType: NSPopUpButton!
    //@IBOutlet weak var ComboAutomaType: NSComboBox!
    
    @IBOutlet weak var RuleField: NSTextField!
    
    @IBOutlet weak var ImageField: NSImageView!
    
    @IBOutlet weak var IKImageViewField: IKImageView!
    
    var AutomaRow: [Bool] = []
    var tmpAutomaRow: [Bool] = []
    
    var BinaryRule:[Bool] = []
    
    var simulationWidth = 2000
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmpAutoma = NSImage(size: NSSize(width: simulationWidth, height: 733))
        tmpAutoma.lockFocus()
        NSColor.whiteColor().set()
        NSRectFill(NSMakeRect(0, 0, CGFloat(simulationWidth), 733))
        tmpAutoma.unlockFocus()
        var imageRect = NSMakeRect(0.0,0.0,tmpAutoma.size.width,tmpAutoma.size.height);
        
       // ImageField.frame=imageRect
        

            var tmpAutomaCGImage : CGImage = nsImageToCGImage(tmpAutoma)
        

        
        IKImageViewField.setImage(tmpAutomaCGImage,imageProperties: nil)
        //ImageField.image = tmpAutoma
        
       // print(ImageField.bounds)
        ComboAutomaType.removeAllItems()
        ComboAutomaType.addItemsWithTitles(["1D-Rule 2-Colors","1D-Rule 3-Colors"])

        for _ in 0...(simulationWidth/2)-1 {
            AutomaRow.append(false)
        }
    }

    func nsImageToCGImage(image: NSImage)->CGImage
    {
    var imgData: NSData = image.TIFFRepresentation!
    var imgRef: CGImageRef? = nil;

     var imageSource: CGImageSource = CGImageSourceCreateWithData(imgData,  nil)!;

    imgRef = CGImageSourceCreateImageAtIndex(imageSource, 0, nil);
    
    
     return imgRef!;
    }
    func drawRow(RowToDraw: [Bool], RowNumber: Int){
        if(RowNumber * 2 > 733){ return }
        for i in 0...(simulationWidth/2)-2{
            if(RowToDraw[i]){
                NSColor.blackColor().set()
                NSRectFill(NSMakeRect(CGFloat(i*2), CGFloat(730-(2*RowNumber)), 2, 2))
            }
        }
    }
    
    func computeNextRow(CurrentRow: [Bool], RuleSet: [Bool])->[Bool]{
        var newRow: [Bool] = []
        newRow.append(false)
        for i in 1...(simulationWidth/2)-2 {
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
        newRow[0]=newRow[1]
        newRow.append(false)
        newRow[(simulationWidth/2)-1] = newRow[(simulationWidth/2)-2]
        
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
                for i in 0...(simulationWidth/2)-1 {
                    if (i==(simulationWidth/4)){
                        AutomaRow[i]=true
                    }else{
                        AutomaRow[i]=false
                    }
                }
                
                let newAutoma = NSImage(size: NSSize(width: simulationWidth, height: 733))
                newAutoma.lockFocus()
                NSColor.whiteColor().set()
                NSRectFill(NSMakeRect(0, 0, CGFloat(simulationWidth), 733))
                drawRow(AutomaRow,RowNumber: 0)
                for i in 1...366{
                    tmpAutomaRow = computeNextRow(AutomaRow,RuleSet: Rule)
                    drawRow(tmpAutomaRow, RowNumber: i)
                    AutomaRow=tmpAutomaRow
                }

                newAutoma.unlockFocus()
                var imageRect = NSMakeRect(0.0,0.0,newAutoma.size.width,newAutoma.size.height);

                var tmpNewAutomaCGImage : CGImage = nsImageToCGImage(newAutoma)
                
                
                
                IKImageViewField.setImage(tmpNewAutomaCGImage,imageProperties: nil)

        }

    
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

