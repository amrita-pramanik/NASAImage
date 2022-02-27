//
//  FavListViewModel.swift
//  FindImages
//
//  Created by Amrita on 27/02/22.
//

import Foundation

struct FavListViewModel {
    
    var favListArr: [NASAImageDataObject]
    
    init() {
        favListArr = [NASAImageDataObject]()
    }
    
    mutating func getSavedFavList() {
        
        var dataArr = [NASAImageDataObject]()
        let savedFavList = LocalDBManager.fetchAllFavRecord()
        for item in savedFavList {
            
            let imageData = NASAImageDataObject(copyright: nil,
                                                date: item.date,
                                                explanation: item.explanation,
                                                hdurl: nil,
                                                media_type: nil,
                                                service_version: nil,
                                                title: item.title,
                                                url: nil,
                                                isFav: item.isFav,
                                                imageData: item.imageData,
                                                isLastVisited: item.isLastViewed)
            
            dataArr.append(imageData)
            
        }
        favListArr = dataArr
    }
    
    mutating func updateFavStatus(atIndex: Int) {
        
        guard favListArr.count > atIndex else {
            return
        }
        
        let imageData = favListArr[atIndex]
        favListArr.remove(at: atIndex)
        if let dateStr = imageData.date {
            let isLastVisited = imageData.isLastVisited
            if isLastVisited == false {
                LocalDBManager.deleteRecord(forDate: dateStr)
            }
            else {
                LocalDBManager.updateFav(favVal: false, forDate: dateStr)
            }
            
        }
        
        
    }
    
}
