//
//  SelectedItemCollectionViewCell.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/20/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import UIKit
import Cosmos

protocol SelectedItemCollectionViewCellDelegate {
    func btnAction(_sender : Any)
}
class SelectedItemCollectionViewCell: UICollectionViewCell {
    
    var delegate : SelectedItemCollectionViewCellDelegate?
    @IBOutlet weak var itemSelectedCount: UILabel!
    @IBAction func addBtnAction(_ sender: Any) {
        if let send = sender as? UIButton {
            send.tag = 1
            delegate?.btnAction(_sender: sender)
        }
        
       
        
    }
    @IBAction func removeBtnAction(_ sender: Any) {
       
        if let send = sender as? UIButton {
            send.tag = 0
             delegate?.btnAction(_sender: sender)
        }
        
    }
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var itemRatingView: CosmosView!
    @IBOutlet weak var itemInfoLbl: UILabel!
    @IBOutlet weak var itemNamelbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!

    
  
}


