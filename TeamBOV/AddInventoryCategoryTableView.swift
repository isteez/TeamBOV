//
//  AddInventoryCategoryTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/22/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class AddInventoryCategoryTableView: UITableViewController, UITextFieldDelegate {
    var hud: Hud!
    var delegate: UpdatingTableViewDelegate?
    
    @IBOutlet weak var categoryName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Inventory Category"
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveNewCategory")
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.enabled = false
        
        var cancelButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "cancelNewCategory")
        navigationItem.leftBarButtonItem = cancelButton
        
        tableView.allowsSelection = false
        
        categoryName.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "categoryCreated:", name: "CategoryCreated", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "CategoryCreated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelNewCategory() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveNewCategory() {
        if categoryName.text != nil {
            hud = Hud(viewFrame: self.view.frame, hudMessage: "Saving")
            hud.StartIndicator()
            self.view.addSubview(hud.HudView())
        
            DataSource.sharedTasks().createNewCategory(categoryName.text)
        } else {
            var alert = UIAlertView(title: "Cannot Save", message: "An category name is needed.", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func categoryCreated(notification: NSNotification) {
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
        
        delegate?.didUpdateData("add", className: "Categories")
    }
    
    // MARK: - Text field delegate
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        navigationItem.rightBarButtonItem?.enabled = true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44;
    }
}
