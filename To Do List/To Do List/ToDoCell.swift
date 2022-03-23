//
//  ToDoCell.swift
//  To Do List
//
//  Created by Islam Abd El Hakim on 18/02/2022.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var toDoImg: UIImageView!
    @IBOutlet weak var toDoTitleLabel: UILabel!
    @IBOutlet weak var toDoCreationDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
