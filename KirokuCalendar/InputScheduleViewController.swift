//
//  InputScheduleViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/24.
//

import UIKit
import RealmSwift

class InputScheduleViewController:  UITableViewController {
    
    // MARK: - receive property
    var date:Date = Date()
    var schedule:ScheduleModels? = nil

    // MARK: - instance
    let realm = try! Realm()
    let df = DateFormatter()
    let df2 = DateFormatter()

    // MARK: - Outlet
    @IBOutlet var titleField:UITextField!
    @IBOutlet var memoField:UITextField!
    @IBOutlet var startDatePicker:UIDatePicker!
    @IBOutlet var endDatePicker:UIDatePicker!
    
    // MARK: - Function
    func validationInput() -> Bool{
        if titleField.text == "" || startDatePicker.date > endDatePicker.date {
            return false
        }
        return true
    }
    // MARK: - Function
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.df.dateFormat = "yyyy年MM月dd日(EEE)"
                
        // MARK: - NavigationItem
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style:.plain, target: self, action: #selector(self.entrySchedule))
        self.navigationItem.rightBarButtonItem = rightButton
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style:.plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = leftButton
        // MARK: - NavigationItem
        
        if schedule == nil{
            titleField.placeholder = "タイトル"
            memoField.placeholder = "メモ"
            startDatePicker.date = date
            endDatePicker.date = date
        }else{
            titleField.text = schedule?.title
            memoField.text = schedule?.memo
            startDatePicker.date = schedule?.start ?? date
            endDatePicker.date = schedule?.end ?? date
        }
    }
    
    // MARK: - Function
    @objc func entrySchedule(){
        if validationInput() {
            
            if schedule == nil{
                let obj = ScheduleModels()
                obj.title = titleField.text!
                obj.memo = memoField.text!
                obj.start = startDatePicker.date
                obj.end = endDatePicker.date

                try! realm.write{
                    realm.add(obj)
                }
                
                if let presentationController = presentationController {
                    presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
                }
                
            }else{
                let result = realm.objects(ScheduleModels.self).first(where: {$0.id == schedule?.id})
                try! realm.write{
                    result?.title = titleField.text!
                    result?.memo = memoField.text!
                    result?.start = startDatePicker.date
                    result?.end = endDatePicker.date
                }
            }
            
           
            self.dismiss(animated: true,completion: nil)
            
        }

    }
    
    @objc func backAction(){
        
        self.dismiss(animated: true,completion: nil)
    }
    // MARK: - Function
}
