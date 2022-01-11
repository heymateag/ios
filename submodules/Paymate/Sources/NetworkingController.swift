//
//  NetworkingController.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import Foundation

protocol NetworkingController {
    func getSubCategories(request:SubCategoryRequest,completion:@escaping(_ result:Result<CategoriesResponse,PeyError>,_ optionalReturnValues:Any?) -> Void)
    func getCategories(request:EmptyRequest,completion:@escaping(_ result:Result<CategoriesResponse,PeyError>,_ optionalReturnValues:Any?) -> Void)
    func getOffers(request:EmptyRequest,completion:@escaping(_ result:Result<OffersResponse,PeyError>,_ optionalReturnValues:Any?) -> Void)
    func getOfferDetails(offerId:String,completion:@escaping(_ result:Result<OfferMoreDetailsResponse,PeyError>,_ optionalReturnValues:Any?) -> Void )
    func getMyOrders(request:EmptyRequest,completion:@escaping(_ result:Result<MyOrderResponse,PeyError>,_ optionalReturnValues:Any?) -> Void)
    func loginUser(request:LoginRequest,completion:@escaping(_ result:Result<LoginResponse,PeyError>,_ optionalReturnValues:Any?) -> Void)
    func createOffer(request:CreateOfferRequest,completion:@escaping(_ result:Result<CreateOfferResponse,PeyError>,_ optionalReturnValues:Any?) -> Void)
    func registerNewUser(request:RegisterRequest,completion:@escaping(_ result:Result<LoginResponse,PeyError>,_ optionalReturnValues:Any?) -> Void)
}

public enum PeyError:Error {
    
    case Non200StatusCodeError(NetworkError)
    case NoNetworkError
    case BadURLError
    case UnParsableError
    case UnknownError
    case UnAuthorized(NetworkError)
    case NoDataAvailableInResponseError(NetworkError)
    case customError(message:String)
    
    
}

public struct NetworkError:Decodable {
    let message:String?
    let error:String?
}
