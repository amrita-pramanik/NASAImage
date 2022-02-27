//
//  SelectedImagesVC.swift
//  FindImages
//
//  Created by Amrita on 26/02/22.
//

import UIKit

class SelectedImagesVC: UIViewController {
    
    @IBOutlet weak var tblFavView: UITableView!
    
    
    var favListViewModel: FavListViewModel?
    let reuseIdentifier = "ImageFavCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favListViewModel = FavListViewModel()
        favListViewModel?.getSavedFavList()
        tblFavView.reloadData()
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        if let presentingVC = self.presentingViewController as? ViewController {
            presentingVC.refreshFavInfo()
        }
        dismiss(animated: true, completion: nil)
    }

}


extension SelectedImagesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return favListViewModel?.favListArr.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageTVCell
        cell.selectionStyle = .none
        
        cell.apiImageData = favListViewModel?.favListArr[indexPath.row]
        cell.imgFav.tag = indexPath.row
        cell.imgFav.addTarget(self, action: #selector(cellFabBtnTapped(_:)), for: .touchUpInside)
        
      return cell
    }
    
    @objc func cellFabBtnTapped(_ sender: UIButton) {        
        favListViewModel?.updateFavStatus(atIndex: sender.tag)
        tblFavView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
