//
//  DetailScheduleViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/27.
//

import UIKit

class DetailScheduleViewController: UITableViewController {
    
    // MARK: - receive property
    var schedule:ScheduleModels? = nil
    
    // MARK: - Outlet
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var memoLabel:UILabel!
    @IBOutlet var startDatePicker:UIDatePicker!
    @IBOutlet var endDatePicker:UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = schedule!.title
        memoLabel.text = schedule!.memo
        startDatePicker.date = schedule!.start
        endDatePicker.date = schedule!.end
        
        // MARK: - NavigationItem
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style:.plain, target: self, action: #selector(self.showInput))
        self.navigationItem.rightBarButtonItem = rightButton
        // MARK: - NavigationItem
    }
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = schedule!.title
        memoLabel.text = schedule!.memo
        startDatePicker.date = schedule!.start
        endDatePicker.date = schedule!.end
    }
    // MARK: - Action
    @objc func showInput(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "InputSchedule") as! InputScheduleViewController
        nextVC.schedule = schedule
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
  
}
