//
//  WeatherAreaTableViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/11/04.
//

import UIKit
import SwiftUI

class WeatherAreaTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Models
    let weatherArea:Array = WeatherArea.allCases
    
    // MARK: - Function
    func judgeWeatherNum() -> Int{
        let userDefaults = UserDefaults.standard
        let area = userDefaults.string(forKey:"weather")
        switch area {
        case WeatherArea.hokkaidou.rawValue:
            return 0
        case WeatherArea.iwate.rawValue:
            return 1
        case WeatherArea.tokyo.rawValue:
            return 2
        case WeatherArea.kanagawa.rawValue:
            return 3
        case WeatherArea.ishikawa.rawValue:
            return 4
        case WeatherArea.aichi.rawValue:
            return 5
        case WeatherArea.oosaka.rawValue:
            return 6
        case WeatherArea.tokushima.rawValue:
            return 7
        case WeatherArea.fukuoka.rawValue:
            return 8
        case WeatherArea.okinawa.rawValue:
            return 9
        case .none:
            return 0
        case .some(_):
            return 0
        }
    }
    
 
    
    // MARK: - delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherArea.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.text = self.weatherArea[indexPath.row].rawValue
        if indexPath.row == judgeWeatherNum(){
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
            userDefaults.set(WeatherArea.hokkaidou.rawValue, forKey: "weather")
        case 1 :
            userDefaults.set(WeatherArea.iwate.rawValue, forKey: "weather")
        case 2 :
            userDefaults.set(WeatherArea.tokyo.rawValue, forKey: "weather")
        case 3 :
            userDefaults.set(WeatherArea.kanagawa.rawValue, forKey: "weather")
        case 4 :
            userDefaults.set(WeatherArea.ishikawa.rawValue, forKey: "weather")
        case 5 :
            userDefaults.set(WeatherArea.aichi.rawValue, forKey: "weather")
        case 6 :
            userDefaults.set(WeatherArea.oosaka.rawValue, forKey: "weather")
        case 7 :
            userDefaults.set(WeatherArea.tokushima.rawValue, forKey: "weather")
        case 8 :
            userDefaults.set(WeatherArea.fukuoka.rawValue, forKey: "weather")
        case 9 :
            userDefaults.set(WeatherArea.okinawa.rawValue, forKey: "weather")
        default:
            userDefaults.set(WeatherArea.okinawa.rawValue, forKey: "weather")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}


enum WeatherArea:String,CaseIterable{
    case hokkaidou = "北海道"
    case iwate = "岩手県"
    case tokyo = "東京都"
    case kanagawa = "神奈川県"
    case ishikawa = "石川県"
    case aichi = "愛知県"
    case oosaka = "大阪府"
    case tokushima = "徳島県"
    case fukuoka = "福岡県"
    case okinawa = "沖縄県"
    
    

}
