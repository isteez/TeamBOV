//
//  AddAccountTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/17/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class AddAccountTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    var hud: Hud!
    var delegate: UpdatingTableViewDelegate?
    
    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var accountUsername: UITextField!
    @IBOutlet weak var accountPassword: UITextField!
    @IBOutlet weak var accountDetails: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Account"

        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveNewAccount")
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.enabled = false
        
        var cancelButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "cancelNewAccount")
        navigationItem.leftBarButtonItem = cancelButton
        
        tableView.allowsSelection = false
        
        accountName.delegate = self;
        accountPassword.delegate = self;
        accountUsername.delegate = self;
        accountDetails.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "accountCreated:", name: "AccountCreated", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "AccountCreated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelNewAccount() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveNewAccount() {
        if accountName.text != nil && accountPassword.text != nil && accountUsername.text != nil {
            hud = Hud(viewFrame: self.view.frame, hudMessage: "Saving")
            hud.StartIndicator()
            self.view.addSubview(hud.HudView())
            
            DataSource.sharedTasks().createNewAccount(
                accountName.text,
                username: accountUsername.text,
                password: accountPassword.text,
                details: accountDetails.text
            )
        } else {
            var alert = UIAlertView(title: "Cannot Save", message: "An account name, username, and password are needed.", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func accountCreated(notification: NSNotification) {
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
        
        delegate?.didUpdateData("add", className: "Accounts")
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
            return 3
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
