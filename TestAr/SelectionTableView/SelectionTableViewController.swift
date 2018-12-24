//
//  SelectionTableViewController.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/6/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import UIKit

class SelectionTableViewController: UITableViewController  {

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "Selection Menu"
         self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.backgroundColor = .clear
//           self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let rotateVC = UIStoryboard(name: "RotateStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
            self.navigationController?.pushViewController(rotateVC, animated: false)
            
        }else if indexPath.row == 1 {
            let chooseVC = UIStoryboard(name: "MenuAR", bundle: nil).instantiateViewController(withIdentifier: "ARViewController")
            self.navigationController?.pushViewController(chooseVC, animated: false)
        }
//        } else if indexPath.row == 2 {
//
//            let portalVC = UIStoryboard(name: "Animation", bundle: nil).instantiateViewController(withIdentifier: "AnimationViewController")
//            self.navigationController?.pushViewController(portalVC, animated: false)
//        }
        else {
            let focusVC = UIStoryboard(name: "FocusSquare", bundle: nil).instantiateViewController(withIdentifier: "FocusSquareViewController")
            self.present(focusVC, animated: true, completion: nil)
        }
    }

    

}
