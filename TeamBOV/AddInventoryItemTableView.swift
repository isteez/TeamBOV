//
//  AddInventoryItemTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/22/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class AddInventoryItemTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    var hud: Hud!
    var delegate: UpdatingTableViewDelegate?
    var category: String!
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemQuantity: UITextField!
    @IBOutlet weak var itemDetails: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Inventory Item"
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveNewItem")
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.enabled = false
        
        var cancelButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "cancelNewItem")
        navigationItem.leftBarButtonItem = cancelButton
        
        tableView.allowsSelection = false
        
        itemName.delegate = self;
        itemQuantity.delegate = self;
        itemDetails.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "itemCreated:", name: "ItemCreated", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "ItemCreated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cancelNewItem() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveNewItem() {
        if itemName.text != nil && itemQuantity.text != nil {
            hud = Hud(viewFrame: self.view.frame, hudMessage: "Saving")
            hud.StartIndicator()
            self.view.addSubview(hud.HudView())
            
            DataSource.sharedTasks().createNewInventoryItem(
                itemName.text,
                quantity: itemQuantity.text.toInt()! as NSNumber,
                details: itemDetails.text,
                category: category
            )
        } else {
            var alert = UIAlertView(title: "Cannot Save", message: "An item name and an item quantity are needed.", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func itemCreated(notification: NSNotification) {
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
        
        delegate?.didUpdateData("add", className: "Inventory")
    }
    
    // MARK: - Text view delegate
    
    func textViewDidBeginEditing(textField: UITextView!) {
        navigationItem.rightBarButtonItem?.enabled = true
    }
    
    // MARK: - Text field delegate
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        navigationItem.rightBarButtonItem?.enabled = true
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44;
        }
        return 100;
    }
}
