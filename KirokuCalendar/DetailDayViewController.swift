//
//  DetailDayViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/24.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class DetailDayViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    // MARK: - receive property
    var date:Date = Date()
    
    // MARK: - instance
    let realm = try! Realm()
    let df = DateFormatter()
    
    // MARK: - data
    var dateArray:Results<DateModels>! = nil
    var scheduleArray:Results<ScheduleModels>! = nil
    
    // MARK: - Outlet
    @IBOutlet var monthLabel:UILabel!
    @IBOutlet var dayLabel:UILabel!
    @IBOutlet var weekLabel:UILabel!
    @IBOutlet var checkmark:UIImageView!
    @IBOutlet var tableView:UITableView!
    
    // MARK: - Function
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
    
    func dataFetch(){
        scheduleArray = realm.objects(ScheduleModels.self)
        scheduleArray = scheduleArray.filter("(start <= %@ && end >= %@) OR start == %@",date,date,date)

    }
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
        
        // MARK: - DateFormat
        df.dateFormat = "d"
        dayLabel.text = df.string(from: date)
        df.dateFormat = "MM"
        monthLabel.text = df.string(from: date) + "月"
        df.dateFormat = "EEE"
        weekLabel.text = df.string(from: date) + "曜日"
        df.dateFormat = "yyyy-MM-dd"
        // MARK: - DateFormat
        
        // MARK: - Data fetch
        dateArray = realm.objects(DateModels.self)
        dataFetch()

        // MARK: - Data fetch
        
        if dateArray.first(where: { $0.date == df.string(from: date) }) != nil {
            let image = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .light, scale: .default))?.withTintColor(selectedColor(), renderingMode: .alwaysOriginal)
            checkmark.image = image
        }else{
            let image = UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .light, scale: .default))?.withTintColor(selectedColor(), renderingMode: .alwaysOriginal)
            checkmark.image = image
        }
        
        //トップに戻るボタンを作成
        let barButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style:.plain, target: self, action: #selector(self.showInputSchedule))
        self.navigationItem.rightBarButtonItem = barButton
        
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
    }
    
    // MARK: - BtnAction
    @objc func showInputSchedule(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "InputSchedule") as! InputScheduleViewController
        nextVC.date = date
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    // MARK: - BtnAction

    
    // MARK: - TableView delegate
    // セル数カウント
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleArray.count
    }
    
    // セル構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell") as! ScheduleTableViewCell
        cell.create(date: date, data: self.scheduleArray[indexPath.row])
        return cell
    }
    
    // スワイプアクション：削除ボタン
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "DetailSchedule") as! DetailScheduleViewController
        nextVC.schedule = scheduleArray[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - TableView delegate
}
