//
//  fetchDateInfoAPI.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/30.
//

import UIKit

class fetchDateInfoAPI: NSObject {
    
    func getDateInfoFromKOYOKMIAPI(completion: @escaping ([String:Any]) -> Void) {
            
        // MARK: - https://koyomi.zingsystem.com/api/
//        {"datelist":{"2022-04-01":{"week":"金","inreki":"卯月","gengo":"令和","wareki":4,"zyusi":"甲","zyunisi":"申","eto":"寅","sekki":"","kyurekiy":2022,"kyurekim":3,"kyurekid":1,"rokuyou":"先負","holiday":""},"2022-04-02":{"week":"土","inreki":"卯月","gengo":"令和","wareki":4,"zyusi":"乙","zyunisi":"酉","eto":"寅","sekki":"","kyurekiy":2022,"kyurekim":3,"kyurekid":2,"rokuyou":"仏滅","holiday":""}}
        
        guard let url = URL(string: "https://tech.amefure.com/rokuyou") else {
            // 無効なURLの場合
            return
        }
        
        let request = URLRequest(url: url)
        
        // URLにアクセス
        URLSession.shared.dataTask(with: request) { data, response, error in
        
            if let data = data {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let dayInfoAPI = dic!["datelist"] as? [String: Any]
                    completion(dayInfoAPI!)
                
                } catch {
//                    print(error.localizedDescription)
                }
            } else {
                // データが取得できなかった場合の処理
//                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()  
        
        
    }

}
