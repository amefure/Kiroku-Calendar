//
//  AccentColorModels.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/21.
//

import UIKit

enum AccentColorModels:String,CaseIterable,Identifiable{
    var id:String{self.rawValue}
    
    case yellow
    case orange
    case red
    case blue
    case indigo
    case green
    case purple

    var thisColor: UIColor{
        switch self {
        case .yellow:
            return UIColor.tintColor
        case .orange:
            return UIColor.orange
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .indigo:
            return UIColor.systemIndigo
        case .green:
            return UIColor.systemGreen
        case .purple:
            return UIColor.purple
        }
    }
    
    
}
