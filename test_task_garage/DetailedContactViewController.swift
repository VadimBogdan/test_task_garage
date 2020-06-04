//
//  DetailedContactViewController.swift
//  test_task_garage
//
//  Created by Вадим on 04.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit

class DetailedContactViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var name: String?
    var surname: String?
    var email: String?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        nameTextField.text = name
        surnameTextField.text = surname
        emailTextField.text = email
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
