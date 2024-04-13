//
//  HistoryItem+CoreDataProperties.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/13/24.
//
//

import Foundation
import CoreData


extension HistoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryItem> {
        return NSFetchRequest<HistoryItem>(entityName: "HistoryItem")
    }

    @NSManaged public var itemId: UUID?
    @NSManaged public var type: String?
    @NSManaged public var city: String?
    @NSManaged public var source: String?
    @NSManaged public var data: [String]

}

extension HistoryItem : Identifiable {

}
