//
//  ButtonTableViewCell.swift
//  TaskSwift3
//
//  Created by Patrick Pahl on 10/17/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.

import UIKit

class ButtonTableViewCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }

    weak var delegate: ButtonTableViewCellDelegate?
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var isCompleteButton: UIButton!
    
    @IBAction func isCompleteButtonTapped(_ sender: AnyObject) {
        
        if let delegate = delegate {
            delegate.buttonCellButtonTapped(sender: self)
        }
    }
    
    func updateWithTask(task: Task) {
        taskNameLabel.text = task.title
        
        if task.isComplete {
            isCompleteButton.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            isCompleteButton.setImage(UIImage(named: "notchecked"), for: .normal)
        }
    }
}


protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(sender: ButtonTableViewCell)
}
