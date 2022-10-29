//
//  SearchScheduleViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/26.
//

import UIKit
import RealmSwift

class SearchScheduleViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - instance
    let realm = try! Realm()
    
    // MARK: - data
    var scheduleArray:Results<ScheduleModels>! = nil
    
    // MARK: - Outlet
    @IBOutlet var searchText:UITextField!
    @IBOutlet var scheduleTable:UITableView!
    @IBOutlet var nodataLabel:UILabel!
    
    // MARK: - 検索アクション
    @IBAction func searchSchedule(){
        if searchText.text != nil {
            nodataLabel.isHidden = true
            scheduleArray = realm.objects(ScheduleModels.self).where({ $0.title.contains(searchText.text!) }).sorted(byKeyPath: "start")
            if scheduleArray.isEmpty {
                nodataLabel.text = "「\(searchText.text!)」にマッチする予定が\n見つかりませんでした。。"
                nodataLabel.isHidden = false
            }
            scheduleTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nodataLabel.isHidden = true
    }
    
    // MARK: - TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleArray != nil{
            return self.scheduleArray.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell") as! ScheduleTableViewCell
        cell.create(date: nil, data: self.scheduleArray[indexPath.row])
        return cell
    }
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "DetailSchedule") as! DetailScheduleViewController
        nextVC.schedule = scheduleArray[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
