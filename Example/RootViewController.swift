//
//  RootViewController.swift
//  Example
//
//  Created by 骆扬 on 2019/3/11.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let distination: ViewController = segue.destination as? ViewController {
            distination.uiType = segue.identifier ?? ""
        }
    }

}
