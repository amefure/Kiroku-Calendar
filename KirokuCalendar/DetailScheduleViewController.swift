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
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = schedule!.title
        memoLabel.text = schedule!.memo
        startDatePicker.date = schedule!.start
        endDatePicker.date = schedule!.end
        loadImage(name: schedule!.image)
        
        
        // MARK: - NavigationItem
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style:.plain, target: self, action: #selector(self.showInput))
        self.navigationItem.rightBarButtonItem = rightButton
        // MARK: - NavigationItem
    }
    
    func loadImage(name:String){
        if name == "blank"{
            imageView.image = nil
        }else{
            let path = docURL("\(name).jpg")!.path
            if FileManager.default.fileExists(atPath: path) {
                if let image = UIImage(contentsOfFile: path) {
                    imageView.image = image
                }
                else {
//                    print("Failed to load the image.")
                }
            }
        }
    }
    
    func docURL(_ fileName:String) -> URL? {
        let fileManager = FileManager.default
        do {
            // Docmentsフォルダ
            let docsUrl = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            // URLを構築
            let url = docsUrl.appendingPathComponent(fileName)
            return url
        } catch {
            return nil
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = schedule!.title
        memoLabel.text = schedule!.memo
        startDatePicker.date = schedule!.start
        endDatePicker.date = schedule!.end
        loadImage(name: schedule!.image)
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
