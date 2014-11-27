//
//  AccountDetailTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/16/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class AccountDetailTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    var accountData: PFObject!
    var hud: Hud!
    var delegate: UpdatingTableViewDelegate?
    
    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var details: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var backbutton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backbutton

        accountName.text = accountData.valueForKey("Name") as String
        username.text = accountData.valueForKey("Username") as String
        password.text = accountData.valueForKey("Password") as String
        
        if ((accountData.valueForKey("Details")) != nil) {
            details.text = accountData.valueForKey("Details") as String
        }
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveAccountInfo")
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.enabled = false
        
        tableView.allowsSelection = false
        
        accountName.delegate = self;
        username.delegate = self
        password.delegate = self
        details.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "accountSaved:", name: "AccountUpdated", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "AccountUpdated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }

    func saveAccountInfo() {
        if accountName.text != nil && password.text != nil && username.text != nil {
            hud = Hud(viewFrame: self.view.frame, hudMessage: "Saving")
            hud.StartIndicator()
            self.view.addSubview(hud.HudView())
            
            accountData.setValue(accountName.text, forKey: "Name")
            accountData.setValue(username.text, forKey: "Username")
            accountData.setValue(password.text, forKey: "Password")
            accountData.setValue(details.text, forKey: "Details")
            
            DataSource.sharedTasks().updateAccountData(accountData)
        } else {
            var alert = UIAlertView(title: "Cannot Save", message: "An account name, username, and password are needed.", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func accountSaved(notification: NSNotification) {
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
        
        delegate?.didUpdateData("update", className: "Accounts")
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
