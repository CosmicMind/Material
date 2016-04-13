//
//  ViewController2.swift
//  TextField
//
//  Created by Ramon Vicente on 4/13/16.
//  Copyright © 2016 CosmicMind, Inc. All rights reserved.
//

import UIKit
import Material

class ViewController2: UIViewController, TextFieldDelegate {
    @IBOutlet weak var nameField: TextField!
    @IBOutlet weak var emailField: TextField!
    
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareNameField()
        prepareEmailField()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /// Prepares the name TextField.
    private func prepareNameField() {
        nameField.placeholder = "First Name"
    }
    
    /// Prepares the email TextField.
    private func prepareEmailField() {
        emailField.delegate = self
        emailField.placeholder = "Email"
        
        /*
         Used to display the error message, which is displayed when
         the user presses the 'return' key.
         */
        emailField.detailLabel = UILabel()
        emailField.detailLabel!.text = "Email is incorrect."
        emailField.detailLabel!.font = RobotoFont.regularWithSize(12)
        emailField.detailLabelActiveColor = MaterialColor.red.accent3
        //		emailField.detailLabelAutoHideEnabled = false // Uncomment this line to have manual hiding.
    }
    
    /// Executed when the 'return' key is pressed when using the emailField.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        (textField as! TextField).detailLabelHidden = 0 == textField.text?.utf16.count
        return false
    }
}