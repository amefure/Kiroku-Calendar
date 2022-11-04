//
//  DetailDayViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/24.
//

import UIKit
import RealmSwift
import GoogleMobileAds
import EventKit
import Contacts

class DetailDayViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    // MARK: - receive property
    var date:Date = Date()
    var dateInfoAPI:[String:Any] = [:] // 六曜
    var weatherAPI:[WeatherData] = [] // 天気予報
    var events: [EKEvent]? = nil //　カレンダーからイベントを取得
    var contacts: [CNContact]? = nil // 連絡先から情報を取得
    
    // MARK: - instance
    let realm = try! Realm()
    let df = DateFormatter()
    
    // MARK: - data
    var dateArray:Results<DateModels>! = nil
    var scheduleArray:Results<ScheduleModels>! = nil
    
    // MARK: - Outlet
    @IBOutlet var monthLabel:UILabel!    // 月
    @IBOutlet var dayLabel:UILabel!      // 日にち
    @IBOutlet var weekLabel:UILabel!     // 曜日ラベル
    @IBOutlet var checkmark:UIImageView! // 継続記録
    @IBOutlet var rokuyouLabel:UILabel!  // 六曜
    @IBOutlet var inrekiLabel:UILabel!   // 陰暦
    @IBOutlet var tableView:UITableView! // テーブルビュー
    @IBOutlet var changeBtn:UIButton!    // カレンダーアプリイベント表示チェンジボタン
    @IBOutlet var calendarLabel:UILabel! // カレンダーアプリ連携時表示ラベル
    @IBOutlet var birthdayLabel:UILabel! // 連絡先連携時表示ラベル
    @IBOutlet var weatherImage:UIImageView!   // 天気予報
    
    
    // MARK: - Function
    // MARK: - ユーザーが選択しているカラーにチェックマークを変更するためのカラーを返すメソッド
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
    
    // MARK: - 表示されている日付に基づいた予定のみを取得する
    func dataFetch(){
        scheduleArray = realm.objects(ScheduleModels.self)
        scheduleArray = scheduleArray.filter("(start <= %@ && end >= %@) OR start == %@",date,date,date)

    }
    
    // MARK: - DataSet
    func setLabelUI(){
        df.dateFormat = "d"
        dayLabel.text = df.string(from: date)
        df.dateFormat = "MM"
        monthLabel.text = df.string(from: date) + "月"
        df.dateFormat = "EEE"
        weekLabel.text = df.string(from: date) + "曜日"
        df.dateFormat = "yyyy-MM-dd"
        
        if dateArray.first(where: { $0.date == df.string(from: date) }) != nil {
            let image = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .light, scale: .default))?.withTintColor(selectedColor(), renderingMode: .alwaysOriginal)
            checkmark.image = image
        }else{
            let image = UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .light, scale: .default))?.withTintColor(selectedColor(), renderingMode: .alwaysOriginal)
            checkmark.image = image
        }
    }
    // MARK: - DataSet
    
    // MARK: - API  六曜や陰暦を取得する
    func setUpDateInfoLabel(){
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = Calendar(identifier: .gregorian)
        let dateStr = df.string(from: self.date)
        let day = self.dateInfoAPI[dateStr] as? [String: Any]
        let dictKeysDay = day?.keys // キー値配列を取得
        
        let userDefaults = UserDefaults.standard
        let rokuyouBool = userDefaults.string(forKey: "rokuyou") ?? "1"
        let inrekiBool = userDefaults.string(forKey: "inreki") ?? "1"
        
        if rokuyouBool == "1" {
            let rokuyou = day?[(dictKeysDay?.first(where: {$0 == "rokuyou"}))!]
            self.rokuyouLabel.isHidden = false
            self.rokuyouLabel.text = rokuyou as? String
        }else{
            self.rokuyouLabel.isHidden = true
        }

        if  inrekiBool == "1"{
            self.inrekiLabel.isHidden = false
            let inreki = day?[(dictKeysDay?.first(where: {$0 == "inreki"}))!]
            self.inrekiLabel.text = inreki as? String
        }
        else{
            self.inrekiLabel.isHidden = true
        }
    }
    // MARK: - API  六曜や陰暦を取得する
    
    
    // MARK: - カレンダーアプリと連携メソッド
    func hasEventsLoaded(){
        calendarLabel.isHidden = true // デフォルトは非表示に
        if events != nil {
            // 連携済
            // 対象の日付を範囲に含んでいるイベントのみにする
            events = events!.filter({$0.startDate <= date && $0.endDate >= date })
            if events!.count == 0{
                calendarLabel.text = "カレンダーに予定はありません。"
            }
            changeBtn.isHidden = false
        }else{
            // 未連携
            changeBtn.isHidden = true
        }
    }
    // MARK: - カレンダーアプリと連携メソッド
    
    // MARK: - 連絡先連携メソッド
    func hasContactLoaded(){
        birthdayLabel.isHidden = true // デフォルトは非表示に
        birthdayLabel.backgroundColor = selectedColor()
        birthdayLabel.layer.opacity = 0.8
        birthdayLabel.layer.cornerRadius = 10
        birthdayLabel.clipsToBounds = true
        
        if contacts != nil {
            // 連携済
            // 対象の日付を範囲に含んでいるイベントのみにする
            let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: date)
            contacts = contacts!.filter({ $0.birthday?.month == dateComponent.month && $0.birthday?.day == dateComponent.day })
            if contacts!.count != 0{
                if contacts!.first != nil{
                    if contacts!.first!.familyName != "" {
                        birthdayLabel.text = contacts!.first!.familyName + "さんの誕生日"
                        birthdayLabel.isHidden = false
                    }else if contacts!.first!.givenName != ""{
                        birthdayLabel.text = contacts!.first!.givenName + "さんの誕生日"
                        birthdayLabel.isHidden = false
                    }
                }
            }
        }
    }
    // MARK: - 連絡先連携メソッド
    
    
    
    // MARK: - 天気予報表示メソッド
    func hasWeatherAPI(){
        self.weatherImage.isHidden = true
        weatherImage.layer.opacity = 0.8
        weatherImage.layer.cornerRadius = 5
        weatherImage.clipsToBounds = true
        if weatherAPI.count != 0 {
            df.dateFormat = "yyyy-MM-dd"
            if let item = weatherAPI.first(where: { $0.date == df.string(from: date) }) {
                self.weatherImage.isHidden = false
                self.weatherImage.image = item.judgeWeatherImage()
            }
        }
    }
    
    // MARK: - 天気予報表示メソッド
    
    // MARK: - Function
    
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
    
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Data fetch
        dateArray = realm.objects(DateModels.self)
        dataFetch()
        // MARK: - Data fetch
        
        // MARK: - DataSet
        setLabelUI()
        
        // MARK: - API  六曜や陰暦を取得する
        setUpDateInfoLabel()
        
        // MARK: - API 天気予報
        hasWeatherAPI()
        
        // MARK: - InputPageへの画面遷移
        let barButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style:.plain, target: self, action: #selector(self.showInputSchedule))
        self.navigationItem.rightBarButtonItem = barButton
        
        // MARK: - カレンダーアプリとの連携識別
        hasEventsLoaded()
        changeBtn.addTarget(self, action: #selector(self.changeCalendarEvent), for: .touchUpInside)
        
        // MARK: - 連絡先との連携識別
        hasContactLoaded()
        
        // MARK: - Admob
        bannerView = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(self.view.frame.size.width))
        addBannerViewToView(bannerView)
        bannerView.adUnitID = AdMobBannerId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        // MARK: - Admob
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataFetch()
        tableView.reloadData()
        hasEventsLoaded()
    }
    
    // MARK: - BtnAction
    // NavigationBtn inputPage
    @objc func showInputSchedule(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "InputSchedule") as! InputScheduleViewController
        nextVC.date = date
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        // 登録処理を押された場合は通常に戻しておく
        changeBtn.tag = 0
        calendarLabel.isHidden = true
    }
    
    //
    @objc func changeCalendarEvent(){
        if changeBtn.tag == 0 {
            changeBtn.tag = 1
            tableView.reloadData()
            calendarLabel.isHidden = false
        }else{
            changeBtn.tag = 0
            tableView.reloadData()
            calendarLabel.isHidden = true
        }
    }
    // MARK: - BtnAction

    
    // MARK: - TableView delegate
    // セル数カウント
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events != nil && changeBtn.tag == 1 {
            return self.events!.count
        }else{
            return self.scheduleArray.count
        }
    }
    
    // セル構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if events != nil && changeBtn.tag == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
            cell.textLabel!.text = events![indexPath.row].title
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell") as! ScheduleTableViewCell
            cell.create(date: date, data: self.scheduleArray[indexPath.row])
            return cell
        }
        
        
    }
    
    // スワイプアクション：削除ボタン
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if events != nil && changeBtn.tag == 1 {
            let configuration = UISwipeActionsConfiguration(actions: [])
            return configuration
        }else{
            let action = UIContextualAction(style: .destructive, title: "") {(action, view, completionHandler) in
                
                let result = self.scheduleArray[indexPath.row]
                try! self.realm.write{
                    self.realm.delete(result)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            action.image = UIImage(systemName: "trash.fill")
            let configuration = UISwipeActionsConfiguration(actions: [action])
            return configuration
        }
    }
    
    // 選択された予定の詳細へ移動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if events != nil && changeBtn.tag == 1 {
            // 何もしない
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "DetailSchedule") as! DetailScheduleViewController
            nextVC.schedule = scheduleArray[indexPath.row]
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    // MARK: - TableView delegate
}
