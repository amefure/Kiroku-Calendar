//
//  SettingTableViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/20.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class SettingTableViewController:UITableViewController {
    
    // MARK: - instance
    let realm = try! Realm()
    let userDefaults = UserDefaults.standard
    
    // MARK: - Outlet
    @IBOutlet var rokuyouSwitch:UISwitch!
    @IBOutlet var inrekiSwitch:UISwitch!
    @IBOutlet var calendarSwitch:UISwitch!
    @IBOutlet var contactSwitch:UISwitch!
    

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Admob
        bannerView = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(self.view.frame.size.width))
        addBannerViewToView(bannerView)
        bannerView.adUnitID = AdMobBannerId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        // MARK: - Admob
    

        setToggleSwitch()
    }
    
    func setToggleSwitch(){
        let rokuyouBool = userDefaults.string(forKey: "rokuyou") ?? "1"
        let inrekiBool = userDefaults.string(forKey: "inreki") ?? "1"
        let calendarBool = userDefaults.string(forKey: "calendar") ?? "1"
        let contactBool = userDefaults.string(forKey: "contact") ?? "1"
        
        
        if rokuyouBool == "1"{
            rokuyouSwitch.isOn = true
        }else{
            rokuyouSwitch.isOn = false
        }
        
        if inrekiBool == "1"{
            inrekiSwitch.isOn = true
        }else{
            inrekiSwitch.isOn = false
        }
        
        if calendarBool == "1"{
            calendarSwitch.isOn = true
        }else{
            calendarSwitch.isOn = false
        }
        
        if contactBool == "1"{
            contactSwitch.isOn = true
        }else{
            contactSwitch.isOn = false
        }
        
        inrekiSwitch.addTarget(self, action: #selector(self.changeInrekiSwitch(sender:)), for:  UIControl.Event.valueChanged)
        rokuyouSwitch.addTarget(self, action: #selector(self.changeRokuyouSwitch(sender:)), for:  UIControl.Event.valueChanged)
        calendarSwitch.addTarget(self, action: #selector(self.changeCalendarSwitch(sender:)), for: UIControl.Event.valueChanged)
        contactSwitch.addTarget(self, action: #selector(self.changeContactSwitch(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func changeRokuyouSwitch(sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        if onCheck {
            userDefaults.set("1", forKey: "rokuyou")
        } else {
            userDefaults.set("0", forKey: "rokuyou")
        }
    }
    
    @objc func changeInrekiSwitch(sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        if onCheck {
            userDefaults.set("1", forKey: "inreki")
        } else {
            userDefaults.set("0", forKey: "inreki")
        }
    }
    
    @objc func changeCalendarSwitch(sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        if onCheck {
            userDefaults.set("1", forKey: "calendar")
        } else {
            userDefaults.set("0", forKey: "calendar")
        }
    }
    
    @objc func changeContactSwitch(sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        if onCheck {
            userDefaults.set("1", forKey: "contact")
        } else {
            userDefaults.set("0", forKey: "contact")
        }
    }
    
    
    // MARK: - delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 // セルの高さ
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK: - 週始め
        if indexPath == [0,0] {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC =  storyboard.instantiateViewController(withIdentifier: "WeekDay")
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        // MARK: - accent color
        if indexPath == [0,1] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "AccentColor")
            navigationController?.pushViewController(nextVC,animated: true)
        }
                
        // MARK: - Reset Data
        if indexPath == [1,0] {
            // アラート表示
            let alert = UIAlertController(title: "データの削除", message: "データを削除してもよろしいですか？", preferredStyle: .alert)
            let delete = UIAlertAction(title: "削除", style: .destructive, handler: { (action) -> Void in
                try! self.realm.write {
                    let objdb = self.realm.objects(DateModels.self)
                    self.realm.delete(objdb)
                }
            })
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                // 何もしない
            })
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
        // 選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    // MARK: - delegate
    
}
