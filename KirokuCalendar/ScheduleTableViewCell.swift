//
//  ScheduleTableViewCell.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/25.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    // MARK: - receive property
    var date:Date? = Date()
    var data:ScheduleModels? = nil
    
    // MARK: - Outlet
    @IBOutlet private weak var titleLabel: UILabel!
//    @IBOutlet private weak var memoLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var prefixsymbolLabel: UILabel!
    @IBOutlet private weak var suffixsymbolLabel: UILabel!
    @IBOutlet private weak var rectangleView: UIView!
        
    // MARK: - instance
    let df = DateFormatter()
    
    func selectedColor() -> UIColor{
    
        let userDefaults = UserDefaults.standard
        let color = userDefaults.string(forKey:"accentColor") ?? "tintColor"
        switch color {
        case AccentColorModels.yellow.rawValue:
            return AccentColorModels.yellow.thisColor
        case AccentColorModels.red.rawValue:
            return AccentColorModels.red.thisColor
        case AccentColorModels.orange.rawValue:
            return AccentColorModels.orange.thisColor
        case AccentColorModels.blue.rawValue:
            return AccentColorModels.blue.thisColor
        case AccentColorModels.indigo.rawValue:
            return AccentColorModels.indigo.thisColor
        case AccentColorModels.green.rawValue:
            return AccentColorModels.green.thisColor
        case AccentColorModels.purple.rawValue:
            return AccentColorModels.purple.thisColor
        default:
            return .tintColor
        }
    }
    
    func create(date:Date?,data:ScheduleModels) {
        if self.date != nil {
            self.date = date
            self.data = data
        }
        titleLabel.text = self.data?.title
        dateLabelCreate(start: self.data!.start ,end:self.data!.end)
    }
    
    func dateLabelCreate(start:Date,end:Date) {
        df.dateFormat = "yyyy-MM-dd"
        dateLabel.isHidden = false
        prefixsymbolLabel.isHidden = false
        suffixsymbolLabel.isHidden = false
        
        // Searchの場合は開始日を格納
        if self.date == nil {
            df.dateFormat = "MM/dd"
            dateLabel.text = df.string(from: start)
            prefixsymbolLabel.isHidden = true
            suffixsymbolLabel.isHidden = true
        }else if end == start {
            // 予定が日にちを跨がない場合は日付のみ
            dateLabel.isHidden = true
            prefixsymbolLabel.isHidden = true
            suffixsymbolLabel.isHidden = true
        }else{
            // 対象の日付より前か後かで記号配置を変更
            if  start < self.date! {
                df.dateFormat = "MM/dd"
                dateLabel.text = df.string(from: start)
                prefixsymbolLabel.isHidden = true
            }else{
                df.dateFormat = "MM/dd"
                dateLabel.text = df.string(from: end)
                suffixsymbolLabel.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rectangleView.backgroundColor = selectedColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
    }
    
}
