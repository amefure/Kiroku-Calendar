//
//  DateModels.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/19.
//

import UIKit
import RealmSwift

// MARK: - Article
class DateModels:Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:ObjectId
    @Persisted var date:String
}
