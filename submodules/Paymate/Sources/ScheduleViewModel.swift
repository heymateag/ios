//
//  ScheduleViewModel.swift
//  _idx_Paymate_CC5DF701_ios_min9.0
//
//  Created by Heymate on 31/10/21.
//

import Foundation

class ScheduleViewModel {
    private var mOffers:[OfferDetails] = []
    private var mOrders:[MyOrder] = []
    
    func offers() -> [OfferDetails] {
        return mOffers
    }
    
    func orders() -> [MyOrder]  {
        return mOrders
    }
    
    func getOffersDisplayTimeRange() {
        
    }
    
    func getMyOffers(observer:@escaping(_ error:PeyError?) -> Void) {
        PeyServiceController.shared.getOffers(request: EmptyRequest()) {[weak self] (result, _) in
            guard let self = self else { return }
            switch result {
            case .success(let offers):
                self.mOffers = offers.data.sorted(by: { (o1, o2) -> Bool in
                    return o1.createdAt > o2.createdAt
                })
                print("mOffers \(offers.data.count)")
                observer(nil)
            case .failure(let error):
                print("getOffers error \(error)")
                observer(error)
            }
        }
    }
    
    func getMyOrders(observer:@escaping(_ error:PeyError?) -> Void) {
        PeyServiceController.shared.getMyOrders(request: EmptyRequest()) {[weak self] (result, _) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mOrders = response.data.sorted(by: { (m1, m2) -> Bool in
                    return m1.createdAt ?? "" > m2.createdAt ?? ""
                })
                print("orders \(response.data.count)")
                observer(nil)
            case .failure(let error):
                print("error on my orders \(error)")
                observer(error)
            }
        }
    }
}
