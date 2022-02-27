//
//  AllImageDataModel.swift
//  FindImages
//
//  Created by Amrita on 25/02/22.
//

import Foundation

struct NASAImageDataObject : Codable {
    let copyright : String?
    let date : String?
    let explanation : String?
    let hdurl : String?
    let media_type : String?
    let service_version : String?
    let title : String?
    let url : String?
    var isFav: Bool?
    var imageData: Data?
    var isLastVisited: Bool?
}
