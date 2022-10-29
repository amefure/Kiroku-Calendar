//
//  firstWeekdayTableViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/20.
//

import UIKit

class WeekdayTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Models
    let weekDay = ["月曜日","火曜日","水曜日","木曜日","金曜日","土曜日","日曜日"]
    
    // MARK: - Function
    func judgeWeekNum() -> Int{
        let userDefaults = UserDefaults.standard
        let weekNum = userDefaults.integer(forKey:"firstWeekday")
        switch weekNum {
        case 0:
            return 5
        case 1:
            return 6
        case 2:
            return 0
        case 3:
            return 1
        case 4:
            return 2
        case 5:
            return 3
        case 6:
            return 4
        default:
            return 5
        }
    }
    
 
    
    // MARK: - delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weekDay.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.text = self.weekDay[indexPath.row]
        if indexPath.row == judgeWeekNum(){
            cell.accessoryType = .checkmark
        }
        return cell
    }
    // MARK: - delegate
    
    
    
    
    // MARK: - delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDefaults = UserDefaults.standard
        switch indexPath.row {
        case 0 :
            userDefaults.set(2, forKey: "firstWeekday")
        case 1 :
            userDefaults.set(3, forKey: "firstWeekday")
        case 2 :
            userDefaults.set(4, forKey: "firstWeekday")
        case 3 :
            userDefaults.set(5, forKey: "firstWeekday")
        case 4 :
            userDefaults.set(6, forKey: "firstWeekday")
        case 5 :
            userDefaults.set(0, forKey: "firstWeekday")
        case 6 :
            userDefaults.set(1, forKey: "firstWeekday")
        default:
            userDefaults.set(1, forKey: "firstWeekday")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
}
