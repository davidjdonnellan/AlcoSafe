//
//  DrinkTableViewCell.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 05/03/2019.
//  Copyright © 2019 CS_UCC. All rights reserved.
//

// Class used as an extenstion of ModelTestViewController
// this class and protocol handles the steppers and labels within each cell of the table
// allows tracks which stepper was pressed and calls function that adds the appropriate drinks to temp dicionary for calculate with the machine learning model

import UIKit

protocol TableViewNew {
    func click(index:Int,stepperV:Int)
}

class DrinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var cellTracker = [Int:Int]()
    var cellDelegate: TableViewNew?
    var index: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0...17 {
            cellTracker[i] = 0
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func stepperClicked(_ sender: UIStepper) {
        cellTracker[(index?.row)!] = Int(stepper.value)
        print(cellTracker)
        cellDelegate!.click(index:(index!.row),stepperV:Int(stepper.value))
        let i = index?.row
        countLabel.text! = String(cellTracker[i!]!)
    }
}
