//
//  AccentColorTableViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/23.
//

import UIKit

class AccentColorTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let AccentColor = AccentColorModels.allCases

    
    // MARK: - delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AccentColor.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.text = self.AccentColor[indexPath.row].rawValue
        let image = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .default))?.withTintColor(self.AccentColor[indexPath.row].thisColor, renderingMode: .alwaysOriginal)
        cell.imageView?.image = image
        if indexPath.row == judgeAccentColor(){
            cell.accessoryType = .checkmark
        }
        return cell
    }
    // MARK: - delegate
    
    func judgeAccentColor()->Int{
        let userDefaults = UserDefaults.standard
        let color = userDefaults.string(forKey: "accentColor")
        switch color {
        case AccentColorModels.yellow.rawValue:
            return 0
        case AccentColorModels.orange.rawValue:        
            return 1
        case AccentColorModels.red.rawValue:
            return 2
        case AccentColorModels.blue.rawValue:
            return 3
        case AccentColorModels.indigo.rawValue:
            return 4
        case AccentColorModels.green.rawValue:
            return 5
        case AccentColorModels.purple.rawValue:
            return 6
     
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDefaults = UserDefaults.standard
        switch indexPath.row {
        case 0 :
            userDefaults.set("yellow", forKey: "accentColor")
        case 1 :
            userDefaults.set("orange", forKey: "accentColor")
        case 2 :
            userDefaults.set("red", forKey: "accentColor")
        case 3 :
            userDefaults.set("blue", forKey: "accentColor")
        case 4 :
            userDefaults.set("indigo", forKey: "accentColor")
        case 5 :
            userDefaults.set("green", forKey: "accentColor")
        case 6 :
            userDefaults.set("purple", forKey: "accentColor")
        default:
            userDefaults.set("yellow", forKey: "accentColor")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
   
}
