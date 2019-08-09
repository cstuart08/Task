//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Cameron Stuart on 8/7/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

protocol TaskTableViewCellDelegate: class {
    func completedButtonChangedStatus(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: TaskTableViewCellDelegate?

    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!

    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.completedButtonChangedStatus(self)
    }
    
    func updateViews() {
        guard let task = task else { return }
        if task.isComplete {
            completeButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            completeButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }
}

extension ButtonTableViewCell {
        func update(withTask task: Task) {
            primaryLabel.text = task.name
        }
    }
