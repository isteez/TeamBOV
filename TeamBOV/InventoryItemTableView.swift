//
//  InventoryItemTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/22/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class InventoryItemTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    var itemData: PFObject!
    var hud: Hud!
    var delegate: UpdatingTableViewDelegate?
    var category: String!
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemQuantity: UITextField!
    @IBOutlet weak var itemDetails: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var backbutton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backbutton
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveAccountInfo")
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.enabled = false
        
        tableView.allowsSelection = false
        
        itemName.delegate = self;
        itemQuantity.delegate = self;
        itemDetails.delegate = self;
        
        itemName.text = itemData.valueForKey("itemName") as String
        itemQuantity.text = NSString(format: "%@", itemData.valueForKey("quantity") as NSNumber)
        
        if ((itemData.valueForKey("details")) != nil) {
            itemDetails.text = itemData.valueForKey("details") as String
        }
    }

    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "itemSaved:", name: "ItemUpdated", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "ItemUpdated", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func saveAccountInfo() {
        if itemName.text != nil && itemQuantity.text != nil {
            hud = Hud(viewFrame: self.view.frame, hudMessage: "Saving")
            hud.StartIndicator()
            self.view.addSubview(hud.HudView())
            
            itemData.setValue(itemName.text, forKey: "itemName")
            itemData.setValue(itemQuantity.text.toInt()! as NSNumber, forKey: "quantity")
            itemData.setValue(itemDetails.text, forKey: "details")
            itemData.setValue(category, forKey: "category")
            
            DataSource.sharedTasks().updateInventoryItemData(itemData)
        } else {
            var alert = UIAlertView(title: "Cannot Save", message: "An item name and an item quantity are needed.", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func itemSaved(notification: NSNotification) {
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
        
        delegate?.didUpdateData("update", className: "Inventory")
    }
    
    // MARK: - Text view delegate
    
    func textViewDidBeginEditing(textView: UITextView) {
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
