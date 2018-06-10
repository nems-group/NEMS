//
//  MessageTableViewCell.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var unreadInd: UIImageView!
    var messageID: UUID?
    var index: IndexPath?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    

}
