//
//  CeloHistory.swift
//  _idx_Paymate_FE5681B0_ios_min12.0
//
//  Created by Sreedeep on 04/03/22.
//

import Foundation

struct CeloHistory:Decodable {
    let result:[Transacttion]?
    struct Transacttion:Decodable {
        let value:String?
        let to:String?
        let tokenSymbol:String?
        let timeStamp:String?
    }
}
