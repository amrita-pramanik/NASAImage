//
//  ImageTVCell.swift
//  FindImages
//
//  Created by Prakash Metia on 25/02/22.
//

import UIKit

class ImageTVCell: UITableViewCell {

    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var imgDesc: UILabel!
    @IBOutlet weak var imgBackVw: UIView!
    
    var imageURL: String? {
        didSet {
            guard let url = imageURL else {
                return
            }
            if (url == ""){
//                DispatchQueue.main.async {
//                    self.img.isUserInteractionEnabled = true
//                    self.cellLoader.stopAnimating()
//                    self.cellLoader.isHidden = true
//                }
                imgCell.image = UIImage(named: "180")
            }else{
               // imgCol.imageFromServerURL(url, placeHolder: UIImage(named: "180")) { image, error in
                DispatchQueue.main.async {
                    self.imgCell.isUserInteractionEnabled = true
//                    self.cellLoader.stopAnimating()
//                    self.cellLoader.isHidden = true
                }
           // }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgBackVw.layer.cornerRadius = 4
        imgBackVw.layer.masksToBounds = true

        imgBackVw.layer.masksToBounds = false
        imgBackVw.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        imgBackVw.layer.shadowColor = UIColor.lightGray.cgColor
        imgBackVw.layer.shadowOpacity = 0.23
        imgBackVw.layer.shadowRadius = 4
        imgCell.layer.cornerRadius = 2
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
        

}
