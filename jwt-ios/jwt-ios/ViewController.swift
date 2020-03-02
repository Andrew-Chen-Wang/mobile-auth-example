//
//  ViewController.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/2/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Hello world!"
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
}
