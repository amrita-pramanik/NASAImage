//
//  ImageTVCell.swift
//  FindImages
//
//  Created by Amrita on 25/02/22.
//

import UIKit

protocol ImageDownloadCompletionProtocol {
    func imageDownloadDidComplete(isDownloadSuccess: Bool, forImageObject: NASAImageDataObject?, image: UIImage?)
}

class ImageTVCell: UITableViewCell {

    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var imgFav: UIButton!
    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var imgDesc: UILabel!
    @IBOutlet weak var favImageShadowView: UIView?
    
    var delegate: ImageDownloadCompletionProtocol?
    
    private var lastViewedImageDetails: NASAImageDataObject?
    var apiImageData: NASAImageDataObject? {
        didSet {
            
            guard apiImageData?.date != lastViewedImageDetails?.date else {
                setFavImage()
                return
            }
            lastViewedImageDetails = apiImageData
            
            imgFav.isHidden = true
            imgCell.image = nil
            imgTitle.text = apiImageData?.title
            imgDesc.text = apiImageData?.explanation
            
            if let imageData = apiImageData?.imageData {
                DispatchQueue.global().async {
                    let imageFromData = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.imgCell.image = imageFromData
                        self.imgFav.isHidden = false
                        self.setFavImage()
                    }
                }
                
            }
            else {
                                        
                imgCell.imageFromServerURL(urlString: apiImageData?.url, PlaceHolderImage: nil) {[weak self] isSuccess in
                    self?.delegate?.imageDownloadDidComplete(isDownloadSuccess: isSuccess, forImageObject: self?.apiImageData, image: self?.imgCell.image)
                    if isSuccess {
                        self?.setFavImage()
                    }
                    
                }
            }
            
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgFav.isHidden = true
        
        favImageShadowView?.layer.cornerRadius = 30
        
        favImageShadowView?.layer.shadowColor = UIColor.black.cgColor
        favImageShadowView?.layer.shadowOpacity = 1
        favImageShadowView?.layer.shadowOffset = .zero
        favImageShadowView?.layer.shadowRadius = 10
    }
    
    private func setFavImage() {
        DispatchQueue.main.async {
            self.imgFav.isHidden = false
            let favValue = self.apiImageData?.isFav ?? false
            print(favValue)
            let image = UIImage(named: favValue ? "heart" : "fav")
            self.imgFav.setBackgroundImage(image, for: .normal)
        }
    }
        

}




extension UIImageView {

    public func imageFromServerURL(urlString: String?, PlaceHolderImage: UIImage?, completion: ((Bool) -> Void)?) {

     guard let urlString = urlString, let url = URL.init(string: urlString) else {
         return
     }
     
     if self.image == nil{
           self.image = PlaceHolderImage
     }

     URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in

         if error != nil {
             print(error ?? "No Error")
             return
         }
         DispatchQueue.main.async(execute: { () -> Void in
             let image = UIImage(data: data!)
             self.image = image
             completion?(true)
         })

     }).resume()
        
    }
    
    
}
