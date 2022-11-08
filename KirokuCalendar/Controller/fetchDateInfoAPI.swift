//
//  fetchDateInfoAPI.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/30.
//

import UIKit

class fetchDateInfoAPI: NSObject {
    
    func validationUrl (urlString: String) -> Bool {
        if let nsurl = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(nsurl as URL)
        }
        return false
    }
    
    func getDateInfoFromKOYOKMIAPI(completion: @escaping ([String:Any]) -> Void) {
            
        // MARK: - https://koyomi.zingsystem.com/api/

        let urlString = "https://tech.amefure.com/rokuyou"
        // 有効なURLかをチェック
        if validationUrl(urlString: urlString) == false {
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        // リクエストを構築
        let request = URLRequest(url: url)
        
        // URLにアクセスしてレスポンスを取得する
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
//                print(error?.localizedDescription ?? "不明なエラー")
            }
        }.resume()     
    }
}
