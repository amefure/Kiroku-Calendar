//
//  fetchWeatherAPI.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/11/02.
//

import UIKit

class fetchWeatherAPI: NSObject {
    
    func validationUrl (urlString: String) -> Bool {
        if let nsurl = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(nsurl as URL)
        }
        return false
    }
    
    func areaCode(_ area:String) -> String{
        switch area {
        case WeatherArea.hokkaidou.rawValue:
            return "016010" // 札幌
        case WeatherArea.iwate.rawValue:
            return "030010" // 盛岡
        case WeatherArea.tokyo.rawValue:
            return "130010" // 東京
        case WeatherArea.kanagawa.rawValue:
            return "140010" // 横浜
        case WeatherArea.ishikawa.rawValue:
            return "170010" // 金沢
        case WeatherArea.aichi.rawValue:
            return "230010" // 名古屋
        case WeatherArea.oosaka.rawValue:
            return "270000" // 大阪
        case WeatherArea.tokushima.rawValue:
            return "360010" // 徳島
        case WeatherArea.fukuoka.rawValue:
            return "400010" // 福岡
        case WeatherArea.okinawa.rawValue:
            return "471010" // 那覇
        default:
            return "230010" // 名古屋
        }
    }
    
    func getWeatherFromTENKIYOHOUAPI(completion: @escaping (Array<Any>?) -> Void) {
        
        // MARK: - https://weather.tsukumijima.net/ // reference
        // MARK: - https://weather.tsukumijima.net/api/forecast/city/400040 // api
        // MARK: - https://weather.tsukumijima.net/primary_area.xml // area
        
        
        let area = UserDefaults.standard.string(forKey:"weather") ?? "愛知県"
        let code = areaCode(area)
        let urlString = "https://weather.tsukumijima.net/api/forecast/city/\(code)"
        // 有効なURLかをチェック
        if validationUrl(urlString: urlString) == false {
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        // リクエストを構築
        let request = URLRequest(url: url)
        
        // URLにアクセス
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if var data = data {
                do {
                    // MARK: - 文字列に変換→改行コードを置換→データ型に変換→辞書型に変換
                    let str = String(data: data, encoding: .utf8)
                    let json = str?.replacingOccurrences(of: "\n", with: "") ?? ""
                    data = json.data(using: .utf8)!
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let weatherAPI = dic!["forecasts"]  as? Array<Any>
                    completion(weatherAPI ?? nil)
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


class WeatherData {
    var date:String = ""
    var weather:String = ""

    func judgeWeatherImage() -> UIImage{
        switch self.weather {
        case "晴れ":
            return UIImage(systemName: "sun.min.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        case "雨":
            return UIImage(systemName: "umbrella.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        case "曇り":
            return UIImage(systemName: "cloud.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        case "曇一時雨":
            return UIImage(systemName: "cloud.rain.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        case "曇のち時々雨":
            return UIImage(systemName: "cloud.rain.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        case "晴時々曇":
            return UIImage(systemName: "cloud.sun.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        case "曇時々晴":
            return UIImage(systemName: "cloud.sun.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        case "曇のち晴":
            return UIImage(systemName: "cloud.sun.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        case "曇のち時々晴":
            return UIImage(systemName: "cloud.sun.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor())!
        default:
            return UIImage(systemName: "sun.min")!.withTintColor(.orange)
        }
    }
}
