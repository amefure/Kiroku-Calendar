//
//  ScheduleModels.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/24.
//

import UIKit
import RealmSwift


// MARK: - 予定情報格納テーブル
class ScheduleModels: Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:ObjectId
    @Persisted var title:String
    @Persisted var memo:String
    @Persisted var start:Date
    @Persisted var end:Date
    @Persisted var image:String
    
    
    func betweenDate(start:String,end:String,date:Date)->Bool{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateStr = df.string(from: date)
        if start <= dateStr && end >= dateStr {
            return true
        }
            return false
    }
    
  
}
