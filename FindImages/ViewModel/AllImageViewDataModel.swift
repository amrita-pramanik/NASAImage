//
//  AllImageViewDataModel.swift
//  FindImages
//
//  Created by Amrita on 25/02/22.
//

import UIKit

class AllImageViewDataModel: NSObject {

    private var apiService : NetworkApiService?
    var selectedDataStr: String?
    
    var nasaImgData: NASAImageDataObject?

var bindImgViewModelToController : (() -> ()) = {}

    override init() {
        super .init()
        selectedDataStr = nil
        if Reachability.isConnectedToNetwork() {
            self.apiService =  NetworkApiService()
            self.callFuncToGetImageData()
        }
        else {
            getLastVisitedData()
        }
        
    }
    
    
    func callFuncToGetImageData() {
        self.apiService?.getData(forDate: selectedDataStr) { [weak self] (jsonResponseData) in
            if let json = jsonResponseData {
                self?.nasaImgData = json
                DispatchQueue.main.async {
                    self?.getFromLocalDB()
                }
                
            }
            
        }
    }
    
    func getFromLocalDB() {
        if let dateStr = self.nasaImgData?.date, let localData = LocalDBManager.fetchRecord(withDate: dateStr) {
            self.nasaImgData?.isFav = localData.isFav
        }
        self.bindImgViewModelToController()
        
    }
    
    private func getLastVisitedData() {
        if let lastRecord = LocalDBManager.fetchLastVisitedRecord() {
            let imageData = NASAImageDataObject(copyright: nil,
                                                date: lastRecord.date,
                                                explanation: lastRecord.explanation,
                                                hdurl: nil,
                                                media_type: nil,
                                                service_version: nil,
                                                title: lastRecord.title,
                                                url: nil,
                                                isFav: lastRecord.isFav,
                                                imageData: lastRecord.imageData,
                                                isLastVisited: lastRecord.isLastViewed)
            nasaImgData = imageData
            bindImgViewModelToController()
        }
    }
    
    
    func saveToLocalDB(withImage: UIImage?) {
        guard var details = nasaImgData, let withImageData = withImage?.jpegData(compressionQuality: 1.0) else {
            return
        }
        details.isLastVisited = true
        LocalDBManager.insertNewImageData(imageDetails: details, imageData: withImageData)
    }
    
    func updateFav() {
        guard var details = nasaImgData, let dateStr = details.date else {
            return
        }
        let favVal = details.isFav ?? false
        details.isFav = !favVal
        nasaImgData = details
        bindImgViewModelToController()
        LocalDBManager.updateFav(favVal: !favVal, forDate: dateStr)
    }
    
}
