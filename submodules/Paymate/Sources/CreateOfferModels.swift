//
//  CreateOfferModels.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import Foundation

struct EmptyRequest:Encodable {
    
}

struct EmptyResponse:Decodable {
    
}

struct SubCategoryRequest:Encodable {
    let category:String
}

struct CategoriesResponse:Decodable {
    let status:Int
    let data:[String]
}



//create offer

public struct OfferCategory:Codable {
    let main_cat:String
    let sub_cat:String
}

public struct OfferLocation:Codable {
     let lat:String
     let long:String
}

public struct OfferPricing:Codable {
    let rate_type:String
    let price:Int
    let currency:String
    let signature:String?
    let bundle:OfferBundle
    let subscription:OfferSubscription
    
    struct OfferBundle:Codable {
        let count:Int
        let discount_percent:Int
        let signature:String?
    }
    
    struct OfferSubscription:Codable {
        let period:String
        let subscription_price:Int
        let signature:String?
    }
}

public struct OfferPaymentTerms:Codable {
    let delay_in_start:DelayInStart
    let cancellation:[Cancellation]
    
    struct DelayInStart:Codable {
        let duration:Int
        let deposit:Int
    }
    
    struct Cancellation:Codable {
        let range:Int
        let penalty:Int
    }
}

public struct CreateOfferRequest:Encodable {
    let title:String
    let description:String
    let category:OfferCategory
    let is_online_meeting = false
    let location:OfferLocation
    let schedules:[OfferSchedule]
    let pricing:OfferPricing
    let payment_terms:OfferPaymentTerms
    let term_condition:String
    let simple_share:String
    let meeting_type:String = "DEFAULT"
    let participants:Int
    let referral_plan:String = "REF"
    
    struct OfferSchedule:Encodable {
        let form_time:String
        let to_time:String
    }
}


//{
//    data =     {
//        category =         {
//            "main_cat" = "Language Learning";
//            "sub_cat" = "Learning German";
//        };
//        createdAt = "2021-11-24T12:55:13.068Z";
//        description = "Older desription";
//        id = "82e42abc-f7e7-4dce-ac4e-8b36f261d719";
//        "is_online_meeting" = 0;
//        location =         {
//            lat = 0;
//            long = 0;
//        };
//        "meeting_type" = DEFAULT;
//        participants = 10;
//        "payment_terms" =         {
//            cancellation =             (
//                                {
//                    penalty = 30;
//                    range = 2;
//                },
//                                {
//                    penalty = 30;
//                    range = 6;
//                }
//            );
//            "delay_in_start" =             {
//                deposit = 21;
//                duration = 25;
//            };
//        };
//        pricing =         {
//            bundle =             {
//                count = 5;
//                "discount_percent" = 12;
//                signature = "";
//            };
//            currency = USD;
//            price = 12;
//            "rate_type" = "Per Item";
//            signature = "";
//            subscription =             {
//                period = "Per month";
//                signature = "";
//                "subscription_price" = 14;
//            };
//        };
//        "referral_plan" = REF;
//        schedules =         (
//                        {
//                "created_at" = "2021-11-24T12:55:13.069Z";
//                "form_time" = 1637758420324;
//                id = "fd2adb31-e000-49a5-8207-5d17160f81a6";
//                offerId = "82e42abc-f7e7-4dce-ac4e-8b36f261d719";
//                "to_time" = 1637762020324;
//                "updated_at" = "2021-11-24T12:55:13.069Z";
//            },
//                        {
//                "created_at" = "2021-11-24T12:55:13.069Z";
//                "form_time" = 1637844823000;
//                id = "5774f767-9c23-4f45-925b-af1d7da47e96";
//                offerId = "82e42abc-f7e7-4dce-ac4e-8b36f261d719";
//                "to_time" = 1637848423000;
//                "updated_at" = "2021-11-24T12:55:13.069Z";
//            }
//        );
//        "simple_share" = "simple or referral ? skip for now";
//        "term_condition" = "Hello\nMulti\nTerms\nConditions ";
//        title = "Baratheon offer";
//        updatedAt = "2021-11-24T12:55:13.068Z";
//        userId = "dfb25fbb-5448-4ef4-8e59-94df56e5ead7";
//    };
//    status = 1;
//}

struct CreateOfferResponse:Decodable {
    let status:Bool?
    let message:String?
}

//My offers

public struct OfferDetails:Codable {
    let location:OfferLocation
    let participants:Int
    let meeting_type:String
    let is_online_meeting:Bool?
    let createdAt:String
    let remainingReservations:Int?
    let userId:String
    let referral_plan:String
    let updatedAt:String
    let completedReservations:Int?
    let category:OfferCategory
    let simple_share:String
    let term_condition:String
    let description:String
    let id:String
    let title:String
    let pricing:OfferPricing
    public let schedules:[OfferDetailsSchedule]
    let payment_terms:OfferPaymentTerms
}

public struct OfferDetailsSchedule:Codable {
    let created_at:String
    let offerId:String
    let id:String
    let to_time:String
    let updated_at:String
    public let form_time:String
}

public struct SingleOfferResponse:Decodable {
    let status:Bool
    public let data:OfferDetails
}

public struct OffersResponse:Decodable {
    let status:Bool
    public let data:[OfferDetails]
}

public struct OfferMoreDetailsResponse:Decodable {
    let status:Int
    public let data:OfferDetails
}

//schedules
public struct MyOrderResponse:Decodable {
    let status:Bool?
    let data:[MyOrder]
}


public struct MyOrder:Decodable {
    let id:String?
    let offer:OfferDetails?
    let time_slot:OfferDetailsSchedule?
    let status:String?
    let meetingId:String?
    let createdAt:String?
    let serviceProviderId:String?
}
