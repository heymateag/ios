//
//  OfferSettingsModel.swift
//  TelegramSample
//
//  Created by Heymate on 24/09/21.
//

import Foundation


struct ParticipantModel {
    var noOfUsers:Int = 0
    var allUsers = true
}

struct OfferSchedule {
    let scheduleDate:Int64
    let endDate:Int64
}

struct CategoryModel {
    let name:String
    var isSelected:Bool
}

struct CategorySelectionModel {
    var category:CategoryModel?
    var subCategory:CategoryModel?
}

struct LocationViewModel {
    var isOnLineMeeting = true
}

struct ExpirationModel {
    var expireDate:Date
}

struct PriceModel {
    var fixed:FixedPrice
    var bundle:Bundle
    var subscription:Subscription
    
    struct FixedPrice {
        var pricePersession:Float
    }
    
    struct Bundle {
        var isChecked = true
        var noOfSessions:Int
        var discount:Int
    }
    
    struct Subscription {
        var isChecked = true
        var pricePerMonth:Float
    }
}

struct PayTermModel {
    enum PaySymbol {
        case GreaterThan
        case LessThan
        case Range
        case None
        
        subscript(getSymbol type:Self) -> String {
            switch type {
                case .GreaterThan: return ">"
                case .LessThan : return ">"
                case .Range : return "-"
                default: return ""
            }
        }
    }
    
    let initialText:String
    let endText:String
    let compareSymbol:PaySymbol
    var startRangeValue:Int
    var endRangeValue:Int
    var compareValue:Int
    var percentage:Int
}
