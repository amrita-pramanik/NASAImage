//
//  LocalDBManager.swift
//  FindImages
//
//  Created by Amrita on 26/02/22.
//

import Foundation
import CoreData
import UIKit

enum LocalDBEntity: String {
    case ImageListTable = "ImageList"
}

struct LocalDBManager {
    
    private static func getCurrentContect() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        return appDelegate.persistentContainer.viewContext
    }
    
    static func insertNewImageData(imageDetails: NASAImageDataObject, imageData: Data?) {
        
        if let dateVal = imageDetails.date {
            deleteAllNonFavData(recentRecordDate: dateVal)
        }
        
        if let managedContext = getCurrentContect() {
            
            if let imageListEntity = NSEntityDescription.entity(forEntityName: LocalDBEntity.ImageListTable.rawValue, in: managedContext) {
                
                let entity = ImageList(entity: imageListEntity, insertInto: managedContext)
                                
                entity.title = imageDetails.title
                entity.date = imageDetails.date
                entity.explanation = imageDetails.explanation
                entity.isFav = imageDetails.isFav ?? false
                entity.imageData = imageData
                entity.isLastViewed = imageDetails.isLastVisited ?? false
                                
                
                do {
                    
                    try managedContext.save()
                    print("Success: Core data insert ...\(imageDetails.date ?? "")-\(imageDetails.title ?? "")")
                }
                catch {
                    print("Error: Core data insert ...\(error.localizedDescription)")
                }

            }
            
        }
    }
    
    
    static func fetchLastVisitedRecord() -> ImageList? {
        
        if let managedContext = getCurrentContect() {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: LocalDBEntity.ImageListTable.rawValue)
            fetchRequest.predicate = NSPredicate(format: "isLastViewed == 1")
            
            do {
                if let result = try managedContext.fetch(fetchRequest) as? [ImageList] {
                    if result.count > 0 {
                        return result[0]
                    }
                }
                
            }
            
            catch {
                print("fetchLastVisitedRecord error ...")
            }
            
        }
        
        return nil
    }
    
    
    static func fetchRecord(withDate: String) -> ImageList? {
        
        if let managedContext = getCurrentContect() {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: LocalDBEntity.ImageListTable.rawValue)
            fetchRequest.predicate = NSPredicate(format: "date == %@", withDate)
            
            do {
                if let result = try managedContext.fetch(fetchRequest) as? [ImageList] {
                    print("fetchRecordFromLocalDB: \(result.count) records ...")
                    if result.count > 0 {
                        return result[0]
                    }
                }
                
            }
            
            catch {
                print("fetchRecordFromLocalDB error ...")
            }
            
        }
        
        return nil
    }
    
    static func fetchAllFavRecord() -> [ImageList] {
        
        if let managedContext = getCurrentContect() {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: LocalDBEntity.ImageListTable.rawValue)
            fetchRequest.predicate = NSPredicate(format: "isFav == 1")
            
            do {
                if let result = try managedContext.fetch(fetchRequest) as? [ImageList] {
                    print("fetchAllFavRecord: \(result.count) records ...")
                    if result.count > 0 {
                        return result
                    }
                }
                
            }
            
            catch {
                print("fetchRecordFromLocalDB error ...")
            }
            
        }
        
        return [ImageList]()
    }
    
    
    static func updateFav(favVal: Bool, forDate: String) {
        
        if let managedContext = getCurrentContect() {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: LocalDBEntity.ImageListTable.rawValue)
            fetchRequest.predicate = NSPredicate(format: "date == %@", forDate)
            
            do {
                
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                    print("updateFav: \(result.count) records ...")
                    if let dataItem = result.first as? ImageList {
                        dataItem.isFav = favVal
                        try managedContext.save()
                    }
                    
                }
                
            }
            
            catch {
                print("updateFav error ...")
            }
            
        }
        
    }
    
    
    static func deleteAllNonFavData(recentRecordDate: String) {
        
        if let managedContext = getCurrentContect() {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: LocalDBEntity.ImageListTable.rawValue)
            //fetchRequest.predicate = NSPredicate(format: "isFav == 0")
            let favPredicate = NSPredicate(format: "isFav == 0")
            let datePredicate = NSPredicate(format: "date == %@", recentRecordDate)
            fetchRequest.predicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: [favPredicate, datePredicate])
            
            do {
                let objects = try managedContext.fetch(fetchRequest)
                for object in objects {
                    if let item = object as? NSManagedObject {
                        managedContext.delete(item)
                    }
                }
                print("deleteAllNonFavData: \(objects.count) record deleted ...")
                try managedContext.save()
            }
            
            catch {
                print("Error: deleteAllNonFavData")
            }
        }
    }
    
    
    
    static func deleteRecord(forDate: String) {
        
        if let managedContext = getCurrentContect() {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: LocalDBEntity.ImageListTable.rawValue)
            fetchRequest.predicate = NSPredicate(format: "date == %@", forDate)
            
            do {
                let objects = try managedContext.fetch(fetchRequest)
                for object in objects {
                    if let item = object as? NSManagedObject {
                        managedContext.delete(item)
                    }
                }
                print("deleteRecord: \(objects.count) record deleted ...")
                try managedContext.save()
            }
            
            catch {
                print("Error: deleteRecord")
            }
        }
    }
    
     
}
