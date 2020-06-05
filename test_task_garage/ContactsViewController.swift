//
//  ContactsTableViewController.swift
//  test_task_garage
//
//  Created by Вадим on 04.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITableViewDataSource {

    let defaultContacts = [
        ["Thomas", "Surname", "example@mail.example"],
        ["Lenny", "Surname", "example@example.com"],
        ["Andre", "Surname", "same@example.com"]
    ]
    
    var contacts = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                           target: self,
                                                           action: #selector(refreshContacts))
    }
    
    @objc func refreshContacts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        for contact in contacts {
            managedContext.delete(contact)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        contacts.removeAll()
        fetchContacts(managedContext)
    }
    
    var lastlySelectedRowIndex: IndexPath?
    
    override func viewWillAppear(_ animated: Bool) {
        if let last = lastlySelectedRowIndex {
            tableView.deselectRow(at: last, animated: true)
            lastlySelectedRowIndex = nil
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        fetchContacts(managedContext)
    }
    
    fileprivate func fetchContacts(_ managedContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        do {
            contacts = try managedContext.fetch(fetchRequest)
            if contacts.count == 0 {
                createContacts(managedContext: managedContext)
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
         tableView.reloadData()
    }
    
    fileprivate func setContactProperties(_ contactData: [String], _ contact: NSManagedObject) {
        let name = contactData[0]
        let surname = contactData[1]
        let email = contactData[2]
        let image = UIImage(named: name + " " + surname)?.pngData()
        contact.setValue(name, forKey: "name")
        contact.setValue(surname, forKey: "surname")
        contact.setValue(email, forKey: "email")
        contact.setValue(image, forKey: "image")
    }
    
    fileprivate func createContacts(managedContext: NSManagedObjectContext) {
        for contactData in defaultContacts {
            let entity = NSEntityDescription.entity(forEntityName: "Contact",
                                                in: managedContext)!
            let contact = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
            setContactProperties(contactData, contact)
            contacts.append(contact)
        }
    }
}

extension ContactsViewController: UITableViewDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

       // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
       // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    fileprivate func setContactTableCellProperties(_ cell: ContactTableViewCell, _ indexPath: IndexPath) {
        let name = contacts[indexPath.row].value(forKeyPath: "name") as! String
        let surname = contacts[indexPath.row].value(forKeyPath: "surname") as! String
        let image = UIImage(data: contacts[indexPath.row].value(forKeyPath: "image") as! Data)
        
        cell.contactFullName.text = name + " " + surname
        cell.contactImage.image = image
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        setContactTableCellProperties(cell, indexPath)

        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.height / 2
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailedContactViewController")
            as? DetailedContactViewController
    
        vc?.contact = contacts[indexPath.row]
        
        lastlySelectedRowIndex = indexPath
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ContactsViewController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            removeContact(contactIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
    
    func removeContact(contactIndex: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(contacts[contactIndex])
        contacts.remove(at: contactIndex)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
}
