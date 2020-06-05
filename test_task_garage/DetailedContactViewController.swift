//
//  DetailedContactViewController.swift
//  test_task_garage
//
//  Created by Вадим on 04.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit
import CoreData

class DetailedContactViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var name: String?
    var surname: String?
    var email: String?
    
    var image: UIImage?
    
    var contact: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = contact {
            name = contact.value(forKeyPath: "name") as? String
            surname = contact.value(forKeyPath: "surname") as? String
            email = contact.value(forKeyPath: "email") as? String
            image = UIImage(data: contact.value(forKeyPath: "image") as! Data)
        }
        
        imageView.image = image
        nameTextField.text = name
        surnameTextField.text = surname
        emailTextField.text = email

        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        
        setTextFieldsIsEnabled(editing)
        
        if !editing {
            saveChanges()
            setTextFieldsTextColor(#colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1))
        } else {
            setTextFieldsTextColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
        
        super.setEditing(editing, animated: animated)
    }
    
    func saveChanges() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        if let contact = contact {
            updateContactProperties(contact: contact)
        } else {
            createCustomContact(managedContext: managedContext)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateContactProperties(contact: NSManagedObject) {
        contact.setValue(nameTextField.text, forKey: "name")
        contact.setValue(surnameTextField.text, forKey: "surname")
        contact.setValue(emailTextField.text, forKey: "email")
        contact.setValue(imageView.image?.pngData(), forKey: "image")
    }
    
    func createCustomContact(managedContext: NSManagedObjectContext) {
        let entity =
          NSEntityDescription.entity(forEntityName: "Contact",
                                     in: managedContext)!
        let contact = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        updateContactProperties(contact: contact)
    }
    
    func setTextFieldsIsEnabled(_ isEnabled: Bool) {
        nameTextField.isEnabled = isEnabled
        surnameTextField.isEnabled = isEnabled
        emailTextField.isEnabled = isEnabled
    }
    
    func setTextFieldsTextColor(_ color: UIColor) {
        UIView.transition(with: nameTextField, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.nameTextField.textColor = color
        })
        UIView.transition(with: surnameTextField, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.surnameTextField.textColor = color
        })
        UIView.transition(with: emailTextField, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.emailTextField.textColor = color
        })
    }
}
