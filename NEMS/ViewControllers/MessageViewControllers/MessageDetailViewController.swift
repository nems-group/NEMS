//
//  MessageDetailViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/12/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var messageDetail: UITextView!
    var delegate: InboxViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let delegate = delegate else {
            print("no delegate")
            return
        }
        guard let id = delegate.selectedUUID else {
            print("no id selected")
            return
        }
        guard let stacks = delegate.messageHandler.dataSource?.messageStacks else {
            print("delegated didnt' have a message stack ready for us")
            return
        }
        
        do {
            let details = try MessageQuery.retrieveMessageDetails(id: id, messageStacks: stacks)
            if details.favorited {
                self.favorite.isSelected = true
            } else {
                self.favorite.isSelected = false
            }
            self.messageDetail.text = details.messageBody
            self.subject.text = details.subject
            
        } catch {
            print(error)
        }
    }

     @IBAction func favorite(_ sender: Any) {
        // MARK: To-do
        guard let id = self.delegate?.selectedUUID else {
            print("no uuid")
            return
        }
        var result: Bool?
        if favorite.isSelected {
            result = self.delegate?.messageHandler.updateMessage(id: id, action: .unfavorite)
            self.favorite.isSelected = false
        } else {
            result = self.delegate?.messageHandler.updateMessage(id: id, action: .favorite)
            self.favorite.isSelected = true
        }
        print(result)
            
    }

    @IBAction func unread(_ sender: Any) {
        // MARK: To-do
        guard let id = self.delegate?.selectedUUID else {
            print("no uuid")
            return
        }
        let result = self.delegate?.messageHandler.updateMessage(id: id, action: .unread)
        print(result)
        self.navigationController?.popViewController(animated: true)
        
    }
}
