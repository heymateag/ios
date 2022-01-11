//
//  PeyServiceController.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import Foundation

private enum ServiceType:String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

public struct PeyServiceController:NetworkingController {
    public static let shared = PeyServiceController()
    private enum StatusCode:Int {
        case Success = 200
        case Created = 201
        case Updated = 202
        case NoDataFound = 404
        case UnAuthorized = 401
    }
    static let enableLogs = false
    static let moreDebuggingInfo = false
    
    func getSubCategories(request: SubCategoryRequest, completion: @escaping (Result<CategoriesResponse, PeyError>, Any?) -> Void) {
        let queryItems = [URLQueryItem(name: "category", value: request.category)]
        networkRequestResult(urlString: Constants.API_GET_SUB_CATEGORIES,urlQueryItems: queryItems, type: .GET, header: nil, encodingData: request, completion: completion)
    }
    
    public func callCategories() {
        getCategories(request: EmptyRequest()) { (_, _) in
            
        }
    }
    
    func getCategories(request: EmptyRequest, completion: @escaping (Result<CategoriesResponse, PeyError>, Any?) -> Void) {
        networkRequestResult(urlString: Constants.API_GET_CATEGORIES,urlQueryItems: [], type: .GET, header: nil, encodingData: request, completion: completion)
    }
        
    func getOffers(request: EmptyRequest, completion: @escaping (Result<OffersResponse, PeyError>, Any?) -> Void) {
        networkRequestResult(urlString: Constants.API_MY_OFFERS,urlQueryItems: [], type: .GET, header: nil, encodingData: request, completion: completion)
//        networkRequestResult(urlString: Constants.API_GET_OFFERS,urlQueryItems: [], type: .GET, header: nil, encodingData: request, completion: completion)
    }
    
    public func getOfferDetails(offerId: String, completion: @escaping (Result<OfferMoreDetailsResponse, PeyError>, Any?) -> Void) {
        networkRequestResult(urlString: "\(Constants.API_GET_SINGLE_OFFER)/\(offerId)", type: .GET, header: nil, encodingData: EmptyRequest(), completion: completion)
    }
    
    func getMyOrders(request: EmptyRequest, completion: @escaping (Result<MyOrderResponse, PeyError>, Any?) -> Void) {
        networkRequestResult(urlString: Constants.API_GET_ORDERS, type: .GET, header: nil, encodingData: EmptyRequest(), completion: completion)
    }
    public func loginUser(request: LoginRequest, completion: @escaping (Result<LoginResponse, PeyError>, Any?) -> Void) {
        networkRequestResult(urlString: Constants.API_LOGIN, type: .POST, header: nil, encodingData: request, completion: completion)
    }
    
    func createOffer(request: CreateOfferRequest, completion: @escaping (Result<CreateOfferResponse, PeyError>, Any?) -> Void) {
        networkRequestResult(urlString: Constants.API_CREATE_OFFER, type: .POST, header: nil, encodingData: request, completion: completion)
    }
    
    public func registerNewUser(request:RegisterRequest,completion:@escaping(_ result:Result<LoginResponse,PeyError>,_ optionalReturnValues:Any?) -> Void) {
        print("request new user \(request)")
        networkRequestResult(urlString: Constants.API_SIGNUP, type: .POST, header: nil, encodingData: request, completion: completion)
    }
}

extension PeyServiceController {
    @discardableResult
    private func networkRequestResult<Q:Encodable,T:Decodable>(urlString:String,urlQueryItems:[URLQueryItem] = [],type:ServiceType,header:[String:String]?,encodedBody multipartBody:Data? = nil,encodingData input:Q?,completion:@escaping(Result<T,PeyError>,Any?) -> Void) -> URLSession {
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(PeyError.NoNetworkError),nil)
            return URLSession(configuration: URLSessionConfiguration.default)
        }
        
        guard var url = URL(string: Constants.BASE_URL+urlString) else {
            completion(.failure(PeyError.BadURLError),nil)
            return URLSession(configuration: URLSessionConfiguration.default)
        }
        
        if !urlQueryItems.isEmpty {
            guard var urlComponents = URLComponents(string:Constants.BASE_URL+urlString) else {
                return URLSession(configuration: URLSessionConfiguration.default)
            }
            urlComponents.queryItems = urlQueryItems
            guard let urlItem = urlComponents.url else {
                return URLSession(configuration: URLSessionConfiguration.default)
            }
            url = urlItem
            print("query param url \(url)")
        }
        
        let config = URLSessionConfiguration.default
        var urlSession = URLSession(configuration:config)
        if let _ = header {
            //                print("header \(header)")
            config.httpAdditionalHeaders = header!
            urlSession = URLSession(configuration: config)
        }
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        if let _ = header {
            for(key,value) in header! {
                print("header key \(key) value \(value)")
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if !AppUtils.getLoginToken().isEmpty {
            request.addValue("Bearer \(AppUtils.getLoginToken())", forHTTPHeaderField: "Authorization")
        }
        if type == .POST {
            do {
                if let mpb = multipartBody {
                    request.httpBody = mpb
                    request.addValue("\(mpb.count)", forHTTPHeaderField: "Content-Length")
                } else if let body = input {
                    request.httpBody = try JSONEncoder().encode(body)
                }
            } catch {
                print("unable to encode input data \(error)")
            }
        }
        
        urlSession.dataTask(with: request) { (responseData, urlResponse, urlError) in
            if PeyServiceController.enableLogs {
                print("request url \(url)")
                do{
                    if let body = request.httpBody {
                        do {
                            let bjson = try JSONSerialization.jsonObject(with: body, options: .allowFragments)
                            print("request body \(bjson)")
                        } catch {
                            print("body parse error \(error)")
                        }
                    }
                    if let r = responseData {
                        let jsonData = try JSONSerialization.jsonObject(with: r, options: [])
                        print("--Server response data json object.--\(jsonData)")
                    }
                } catch{
                    print("**No parsable data recieved!**")
                }
            }
            
            guard urlError == nil else {
                DispatchQueue.main.async { completion(.failure(PeyError.customError(message: urlError?.localizedDescription ?? "")),nil) }
                return
            }
            if let response = urlResponse,response is HTTPURLResponse {
                guard let data = responseData else {
                    DispatchQueue.main.async { completion(.failure(PeyError.NoDataAvailableInResponseError(NetworkError(message: "", error: ""))),nil)
                    }
                    return
                }
                if PeyServiceController.moreDebuggingInfo {
                    print("str response \(String(data:data,encoding: .utf8) ?? "NA")")
                }
                print("status code \((response as! HTTPURLResponse).statusCode)")
                let statusCode = (response as! HTTPURLResponse).statusCode
                if statusCode == StatusCode.Success.rawValue || statusCode == StatusCode.Created.rawValue {
                    do {
                        let decoder = JSONDecoder()
                        let values = try decoder.decode(T.self, from: data)
                        DispatchQueue.main.async { completion(.success(values),nil )}
                    } catch {
                        print("POST API Response parse error \(error)")
                        if statusCode == StatusCode.NoDataFound.rawValue {
                            DispatchQueue.main.async {
                                completion(.failure(PeyError.NoDataAvailableInResponseError(NetworkError(message: "", error: ""))),nil)
                            }
                        } else if statusCode == StatusCode.UnAuthorized.rawValue {
                            DispatchQueue.main.async {
                                if let e = try? JSONDecoder().decode(NetworkError.self, from: data) {
                                    completion(.failure(PeyError.UnAuthorized(e)),nil)
                                } else {
                                    completion(.failure(PeyError.UnAuthorized(NetworkError(message: "", error: ""))),nil)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(.failure(PeyError.UnParsableError),nil)
                            }
                        }
                    }
                } else {
                    if statusCode == StatusCode.UnAuthorized.rawValue {
                        print("calling login")
                        DispatchQueue.main.async {
                            self.loginUser(request: LoginRequest()) { (response, _) in
                                switch response {
                                case .success(let login):
                                    AppUtils.saveLoginToken(token: login.idToken?.jwtToken ?? "")
                                case .failure(let error):
                                    print("login error \(error)")
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        do{
                            let values:NetworkError = try JSONDecoder().decode(NetworkError.self, from: data)
                            completion(.failure(PeyError.Non200StatusCodeError(values)),nil)
                        }catch{
                            completion(.failure(PeyError.NoDataAvailableInResponseError(NetworkError(message: "", error: ""))),nil)
                        }
                    }
                }
            } else {
                print("UnknownError")
                DispatchQueue.main.async { completion(.failure(PeyError.UnknownError),nil) }
            }
        }.resume()
        return urlSession
    }
    
}
