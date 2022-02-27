//
//  ViewController.swift
//  FindImages
//
//  Created by Amrita on 25/02/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    let reuseIdentifier = "ImageCell"
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var viewDatePicker: UIView?
    @IBOutlet weak var viewBackDatePicker: UIView?
    @IBOutlet weak var lblDate: UILabel?
    
    var viewModel : AllImageViewDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        let dateStr = getSelectedDate()
        lblDate?.text = "Date: " + (dateStr ?? "")
        viewDatePicker?.isHidden = true
        viewBackDatePicker?.isHidden = true
        datePicker?.maximumDate = Date()
        tblView.estimatedRowHeight = 400
        tblView.rowHeight = UITableView.automaticDimension
        tblView.dataSource = self
        tblView.delegate = self
 
        viewModel = AllImageViewDataModel()
        viewModel?.bindImgViewModelToController  = {
            DispatchQueue.main.async {
                self.tblView.reloadData()
                print(self.viewModel?.nasaImgData?.title ?? "")
            }
            
        }
        
    }
    
    private func getSelectedDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: datePicker?.date ?? Date())
        return dateStr
    }
    
    @IBAction func favourite(_ sender: UIButton) {
        if let favVC = storyboard?.instantiateViewController(withIdentifier: "SelectedImagesVC") {
            present(favVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func BtnOpenPicker(_ sender: UIButton) {
        viewDatePicker?.isHidden = false
        viewBackDatePicker?.isHidden = false
    }
    
    @IBAction func BtnSaveDate(_ sender: UIButton) {
        viewDatePicker?.isHidden = true
        viewBackDatePicker?.isHidden = true
        let dateStr = getSelectedDate()
        lblDate?.text = "Date: " + (dateStr ?? "")
        viewModel?.selectedDataStr = dateStr
        viewModel?.callFuncToGetImageData()
    }
    
    @IBAction func BtnCloseDatePicker(_ sender: UIButton) {
        viewDatePicker?.isHidden = true
        viewBackDatePicker?.isHidden = true
    }
    
    func refreshFavInfo() {
        viewModel?.getFromLocalDB()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageTVCell
        cell.selectionStyle = .none
        
        cell.delegate = self
        cell.apiImageData = viewModel?.nasaImgData
        cell.imgFav.tag = indexPath.row
        cell.imgFav.addTarget(self, action: #selector(cellFabBtnTapped(_:)), for: .touchUpInside)
        
      return cell
    }
    
    @objc func cellFabBtnTapped(_ sender: UIButton){
        viewModel?.updateFav()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension ViewController: ImageDownloadCompletionProtocol {
    func imageDownloadDidComplete(isDownloadSuccess: Bool, forImageObject: NASAImageDataObject?, image: UIImage?) {
        if isDownloadSuccess {
            viewModel?.saveToLocalDB(withImage: image)
        }
    }
}
