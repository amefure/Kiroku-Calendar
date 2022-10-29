//
//  InputScheduleTableViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/25.
//

import UIKit
import RealmSwift

class InputScheduleTableViewController: UITableViewController {
    // MARK: - receive property
    var date:Date = Date()

    // MARK: - instance
    let realm = try! Realm()
    let df = DateFormatter()
    
    var scheduleArray:Results<ScheduleModels>! = nil

    // MARK: - Outlet

    override func viewDidLoad() {
        super.viewDidLoad()
        
        df.dateFormat = "yyyy-MM-dd"
        // MARK: - DateFormat
        
        // MARK: - Data fetch
        // MARK: - Data fetch
        //トップに戻るボタンを作成
        scheduleArray = realm.objects(ScheduleModels.self)
        // MARK: - Data fetch

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"),style: .plain, target: self, action: nil)

    }

    @objc func backAction(){
        self.dismiss(animated: true,completion: nil)
    }
    
    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleArray.count
    }
    
    
    // MARK: - delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // セルの高さ
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.text = self.scheduleArray[indexPath.row].title
        return cell
    }


    
}
