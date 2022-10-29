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
    
    }
    
    
    // MARK: - delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // セルの高さ
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == [0,0] {
            // 週始め
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC =  storyboard.instantiateViewController(withIdentifier: "WeekDay")
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath == [0,1] {
            // accent color
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "AccentColor")
            navigationController?.pushViewController(nextVC,animated: true)
        }
        
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
