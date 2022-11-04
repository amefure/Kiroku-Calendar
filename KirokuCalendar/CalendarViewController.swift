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
    let eventController = EventController()         // カレンダー連携
    let contactController = ContactController()     // 連絡先連携
    let noticeController = NotificationController() // 通知設定(バッジ)
    
    // MARK: - data
    var dateArray:Results<DateModels>! = nil         // 継続記録データ
    var scheduleArray:Results<ScheduleModels>! = nil // 予定データ
    
    // MARK: - API  六曜や陰暦を取得する
    var dateInfoAPI:[String:Any] = [:]
    
    // MARK: - API  天気予報
    var weatherAPI:[WeatherData] = []
    
    // MARK: - Outlet
    @IBOutlet weak var calender:FSCalendar!
    @IBOutlet var entryBtn:UIButton!
    @IBOutlet var addBtn:UIButton!
    
    // MARK: - variable
    var selectedDate:Date = Date()   // 日付2回連続選択時画面遷移用
    var selectedDateTag:Bool = false // 日付2回連続選択時画面遷移用
    
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
        // カレンダー設定:週はじめ
        let userDefaults = UserDefaults.standard
        let weekNum = userDefaults.integer(forKey:"firstWeekday") // 未設定なら0になる
        if weekNum == 0 {
            // 0を指定すると土曜が月曜になるので7を指定
            calender.firstWeekday = 7
        }else{
            calender.firstWeekday = UInt(weekNum)
        }
       
    }
    
    func hasDateAction(){
        // 表示するビューをデータに基づいて変更
        self.dateArray = realm.objects(DateModels.self)
        self.scheduleArray = realm.objects(ScheduleModels.self)
    
        self.df.dateFormat = "yyyy-MM-dd"
        
        // MARK: - 継続記録ボタンのビューを変更
        if dateArray.first(where: { $0.date == df.string(from: selectedDate ) }) != nil {
            entryBtn.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .default))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            entryBtn.tag = 1
        }else{
            entryBtn.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .default))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            entryBtn.tag = 0
        }
    }
    
    // MARK: - ユーザーが選択しているテーマカラー
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
    
    // MARK: - API  六曜や陰暦を取得する
    func loadDateAPI() {
        let userDefaults = UserDefaults.standard
        let rokuyouBool = userDefaults.string(forKey: "rokuyou") ?? "1"
        let inrekiBool = userDefaults.string(forKey: "inreki") ?? "1"
        
        if rokuyouBool == "1" || inrekiBool == "1"{
            // ユーザーフラグどちらかONならAPI読み込み
            let api = fetchDateInfoAPI()
            api.getDateInfoFromKOYOKMIAPI { data in
                    DispatchQueue.main.async {
                        self.dateInfoAPI = data
                    }
                }
        }
    }
    
    // MARK: - API  六曜や陰暦を取得する
    func loadWeatherAPI() {
        // ユーザーフラグどちらかONならAPI読み込み
        weatherAPI = []
        let api = fetchWeatherAPI()
        api.getWeatherFromTENKIYOHOUAPI { data in
                DispatchQueue.main.async {
                    if data != nil{
                        for item in data! {
                            let weatherDic = item as? [String:Any]
                            let obj = WeatherData()
                            obj.date = weatherDic?["date"] as! String
                            obj.weather = weatherDic?["telop"] as! String
                            self.weatherAPI.append(obj)
                        }
                    }
                }
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
        
        // MARK: -　最初のみ当日の日付の時間まで保持しているため、時間を除外　日付のみに df.dateFormat = "yyyy-MM-dd"
        let dateStr = df.string(from: Date())
        selectedDate = df.date(from:dateStr)!
        
        // MARK: - API  六曜や陰暦を取得する (1)
        loadDateAPI()
        loadWeatherAPI()
        // MARK: - カレンダーの読み込み識別→承認済みならプロパティに値が格納される (2)
        eventController.judgeUserSetting()
        // MARK: - 連絡先読み込み識別→承認済みならプロパティに値が格納される (3)
        contactController.judgeUserSetting()
        // MARK: - バッジセット (4)
        setbadge()
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigationから戻った時に画面をリセット
        hasDateAction()
        calenderSetting()
        calender.reloadData()
        
        // MARK: - API  六曜や陰暦を取得する (1)
        loadDateAPI()
        loadWeatherAPI()
        // MARK: - カレンダーの読み込み識別→承認済みならプロパティに値が格納される (2)
        eventController.judgeUserSetting()
        // MARK: - 連絡先読み込み識別→承認済みならプロパティに値が格納される (3)
        contactController.judgeUserSetting()
        // MARK: - バッジセット (4)
        setbadge()
      }
      
    
    // MARK: - 継続記録を登録するボタン(下部中央)
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
    
    // MARK: - 予定登録ページ遷移ボタン(下部右)
    @objc func showInput(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "InputSchedule") as! InputScheduleViewController
        nextVC.date = selectedDate
        nextVC.presentationController?.delegate = self
        let navigationController = UINavigationController(rootViewController: nextVC)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    // MARK: - 今日の日付にカレンダーを戻すボタン(Navigation)
    @IBAction func todayBackView(){
        calender.currentPage = Date()
    }
    
    // MARK: - Input登録後にカレンダーを更新する
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        calender.reloadData()
     }

    // MARK: - バッジ登録処理
    func setbadge(){
        var date = Date()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = Calendar(identifier: .gregorian)
        let dateStr = df.string(from: date)
        date = df.date(from: dateStr)!
        let scheduleNum = scheduleArray.filter("(start <= %@ && end >= %@) OR start == %@",date,date,date).count
        noticeController.setbadgeNumber(num: scheduleNum)
    }
    
    
    // MARK: - FSCalender delegate
    // MARK: - 選択された日付の詳細ページへ(2回クリックされた時のみ)
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        if selectedDate == date {
            df.dateFormat = "yyyy-MM-dd"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "DetailDay") as! DetailDayViewController
            nextVC.date = date
            nextVC.dateInfoAPI = dateInfoAPI
            nextVC.weatherAPI = weatherAPI
            nextVC.events = eventController.events
            nextVC.contacts = contactController.contacts
            navigationController?.pushViewController(nextVC, animated: true)
        }else{
            selectedDate = date
        }
        hasDateAction()
    }
    
    // MARK: - 継続記録イメージを表示
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let image = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .default))?.withTintColor(selectedColor(), renderingMode: .alwaysOriginal)

        if dateArray.first(where: { $0.date == df.string(from: date) }) != nil {
            return image
        }
        return nil
    }
    
    // MARK: -  予定のある日付の文字色を変更する　FSCalendarDelegateAppearanceが必要
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        df.dateFormat = "yyyy-MM-dd"
        if (scheduleArray.first(where: { $0.betweenDate(start: df.string(from:$0.start), end:  df.string(from:$0.end), date: date) == true }) != nil) {
            return .orange
        }
        return appearance.titleDefaultColor
      }
    // MARK: - FSCalender delegate
}

