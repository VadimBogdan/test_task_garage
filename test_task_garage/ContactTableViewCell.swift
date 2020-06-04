//
//  ContactTableViewCell.swift
//  test_task_garage
//
//  Created by Вадим on 04.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactFullName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
