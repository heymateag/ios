//
//  ViewTagConstants.swift
//  _idx_Paymate_0EEE5C76_ios_min9.0
//
//  Created by Heymate on 29/10/21.
//

import Foundation

enum OfferTags:Int {
    case TagOfferName=100,TagOfferCategory=101,TagOfferMode=102,
         TagOfferDescription=103,
         TagOfferSingle=104,TagOfferSinglePrice=105,TagSingleDetails=106,
         TagOfferBundle=107,TagOfferDiscountView=108,TagOfferDiscount=109,
         TagBundlePrice=110,TagBundleDetails=111,
         TagSubscription=112,TagSubPrice=113,TagSubDetails=114,
         TagOfferShare=115,TagOfferForward=116,
         TagOfferSeeMore=117,TagOfferBookNow=118,
         TagParentHolderView=119
}

enum ScheduleHeaderViewTags:Int {
    case MyOffersBtn=100,MyOffersBadge=101,MyOffersBorderView=102,
         MyOrdersBtn=103,MyOrdersBadge=104,MyOrdersBorderView=105,
         TimeLineRange=106,FilterBtn=107
}

enum ScheduleCellTags:Int {
    case AvatarImage=100,Name=101,OfferDetails=102,StatusLabel=103,MoreButton=104,
         TimeTickilingImage=105,CountDowntimer=106,ConfirmationBtn=107,BottomStackView=108,StatusLableView=109
}

enum NewOfferButton:Int {
    case NewOffer = 100
}

enum OfferDetailsHeaderCellTags:Int {
    case TagOfferName=100,TagOfferCategory=101,
         TagOfferDescription=103,
         TagOfferSingle=104,TagOfferSinglePrice=105,TagSingleDetails=106,
         TagOfferBundle=107,TagOfferDiscountView=108,TagOfferDiscount=109,
         TagBundlePrice=110,TagBundleDetails=111,
         TagSubscription=112,TagSubPrice=113,TagSubDetails=114,
         TadCreated=115,TadExpired=116
}

enum OfferDetailsPaymentCell:Int {
    case TagTermTitle = 100,TagTermsDetails
}
