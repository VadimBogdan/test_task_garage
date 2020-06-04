//
//  ContactsTableViewController.swift
//  test_task_garage
//
//  Created by Вадим on 04.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource {

    let users = [
        ["Thomas", "Surname", "example@mail.example"],
        ["Lenny", "Surname", "example@example.com"],
        ["Andre", "Surname", "same@example.com"]
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var lastlySelectedRowIndex: IndexPath?
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let last = lastlySelectedRowIndex {
            tableView.deselectRow(at: last, animated: true)
            lastlySelectedRowIndex = nil
        }
    }
}

extension ContactsViewController: UITableViewDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

       
       // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
       // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
       
       @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        cell.contactFullName.text = users[indexPath.row][0] + " " + users[indexPath.row][1]
        cell.contactImage.image = UIImage(named: users[indexPath.row][0] + " " + users[indexPath.row][1])
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.height / 2
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailedContactViewController")
            as? DetailedContactViewController
        
        vc?.name = users[indexPath.row][0]
        vc?.surname = users[indexPath.row][1]
        vc?.email = users[indexPath.row][2]
        vc?.image =  UIImage(named: users[indexPath.row][0] + " " + users[indexPath.row][1])
        
        lastlySelectedRowIndex = indexPath
        navigationController?.pushViewController(vc!, animated: true)
    }
}
