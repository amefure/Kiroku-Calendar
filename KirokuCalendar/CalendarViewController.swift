//
//  ViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/19.
//

import UIKit
import FSCalendar
import RealmSwift
import GoogleMobileAds



class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance ,UIAdaptivePresentationControllerDelegate{
    
    // MARK: - instance
    let realm = try! Realm()
    let df = DateFormatter()
    
    // MARK: - data
    var dateArray:Results<DateModels>! = nil
    var scheduleArray:Results<ScheduleModels>! = nil
    
    
    // MARK: - Outlet
    @IBOutlet weak var calender:FSCalendar!
    @IBOutlet var entryBtn:UIButton!
    @IBOutlet var addBtn:UIButton!
    
    // MARK: - variable
    var color:String = "tintColor"
    var selectedDate:Date = Date()
    var selectedDateTag:Bool = false
    
    // MARK: - Admob
    var bannerView: GADBannerView!
    lazy var AdMobBannerId: String = {
        return Bundle.main.object(forInfoDictionaryKey: "AdMobBannerId") as! String
    }()
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem:  view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    // MARK: - Admob
    

    // MARK: - Function
    func calenderSetting(){
        // カレンダー設定
        let userDefaults = UserDefaults.standard
        let weekNum = userDefaults.integer(forKey:"firstWeekday")
        calender.firstWeekday = UInt(weekNum)
    }
    
    func hasDateAction(){
        // 表示するビューをデータに基づいて変更
        self.dateArray = realm.objects(DateModels.self)
        self.scheduleArray = realm.objects(ScheduleModels.self)
    
        self.df.dateFormat = "yyyy-MM-dd"
        
        if dateArray.first(where: { $0.date == df.string(from: selectedDate ) }) != nil {
            entryBtn.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .default))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            entryBtn.tag = 1
        }else{
            entryBtn.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .default))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            entryBtn.tag = 0
        }
    }
    
    func selectedColor() -> UIColor{
    
        let userDefaults = UserDefaults.standard
        self.color = userDefaults.string(forKey:"accentColor") ?? "tintColor"
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
    // MARK: - Function
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - ライトモード
        self.overrideUserInterfaceStyle = .light
       
        hasDateAction()
        entryBtn.addTarget(self, action: #selector(self.entryDate), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(self.showInput), for: .touchUpInside)
        calenderSetting()
        
        // MARK: - Admob
        bannerView = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(self.view.frame.size.width))
        addBannerViewToView(bannerView)
        bannerView.adUnitID = AdMobBannerId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        // MARK: - Admob
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigationから戻った時に画面をリセット
        hasDateAction()
        calenderSetting()
        calender.reloadData()
      }
      
    
    // MARK: - Action
    @objc func entryDate(){
        if entryBtn.tag == 0 {
            try! realm.write {
                let obj = DateModels()
                obj.date = df.string(from: selectedDate)
                realm.add(obj)
            }
            self.calender.reloadData()
            entryBtn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            entryBtn.tag = 1
        }else{
            let result = realm.objects(DateModels.self).where({ $0.date == df.string(from: selectedDate) })
            try! self.realm.write{
                self.realm.delete(result)
            }
            self.calender.reloadData()
            entryBtn.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
            entryBtn.tag = 0
        }
    }
    
    // MARK: - Action
    @objc func showInput(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "InputSchedule") as! InputScheduleViewController
        nextVC.date = selectedDate
        nextVC.presentationController?.delegate = self
        let navigationController = UINavigationController(rootViewController: nextVC)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    // Input登録後にカレンダーを更新する
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        calender.reloadData()
     }

    // MARK: - delegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        if selectedDate == date {
            df.dateFormat = "yyyy-MM-dd"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "DetailDay") as! DetailDayViewController
            nextVC.date = date
            navigationController?.pushViewController(nextVC, animated: true)
        }else{
            selectedDate = date
        }
        hasDateAction()
    }
    
    // 継続記録を表示
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let image = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .default))?.withTintColor(selectedColor(), renderingMode: .alwaysOriginal)

        if dateArray.first(where: { $0.date == df.string(from: date) }) != nil {
            return image
        }
        return nil
    }
    
    // FSCalendarDelegateAppearanceが必要
    // 日付の文字色を変更する
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        df.dateFormat = "yyyy-MM-dd"
        
        
        if (scheduleArray.first(where: { $0.betweenDate(start: df.string(from:$0.start), end:  df.string(from:$0.end), date: date) == true }) != nil) {
            return .orange
        }
        return appearance.titleDefaultColor
      }
    
    
}

