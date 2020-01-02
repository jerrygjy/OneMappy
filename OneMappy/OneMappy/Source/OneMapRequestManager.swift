//
//  OneMapRequestManager.swift
//  onemobileapp
//
//  Created by Jerry Goh on 11/9/18.
//  Copyright © 2018 govtech. All rights reserved.
//

import UIKit

public final class OneMapRequestManager: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    var queue = OperationQueue()
    public static let sharedInstance = OneMapRequestManager()
    
    let OneMap_API_ReverseGeocode: String =  "https://developers.onemap.sg/privateapi/commonsvc/revgeocode"
    let OneMap_API_Search: String =  "https://developers.onemap.sg/commonapi/search"
    let OneMap_API_Route: String =  "https://developers.onemap.sg/privateapi/routingsvc/route"
    let OneMap_API_GetToken: String =  "https://developers.onemap.sg/privateapi/auth/post/getToken"
    
    public override init() {
        
    }
    
    func appendTokenToParam(inputParam: Dictionary<String, Any>)->Dictionary<String, Any> {
        
        var savedToken = UserDefaults.standard.string(forKey: "oneMapToken") ?? ""
        _ = UserDefaults.standard.string(forKey: "oneMapTokenValidity") ?? ""
        var  expirydate = Date()
        let tokenValidity = UserDefaults.standard.string(forKey: "oneMapTokenValidity") ?? ""
        
        
        if tokenValidity != "" {
            let valid_interval = Double(tokenValidity)
            let interval = TimeInterval.init(valid_interval!)
            expirydate = Date(timeIntervalSince1970:interval)
            
        } else {
            savedToken = self.postGetTokenSync()
        }
        
        
        if expirydate .compare(Date()) == .orderedDescending {
            //Valid
            if savedToken == "" {
                savedToken = self.postGetTokenSync()
                
            }
        } else {
            savedToken = self.postGetTokenSync()
        }
        var requestParam = inputParam
        requestParam["token"] = savedToken
        
        return requestParam
    }
    
    ////////////////////////////////////////////////////////////////
    
    //MARK:Get OneMapToken From SLA
    
    ////////////////////////////////////////////////////////////////
    
    func postGetTokenSync() -> String {
        
        let url: String = OneMap_API_GetToken
        let username  = ""
        let password = ""
        
        var paramDict = Dictionary<String, String>()
        
        paramDict["email"] = username
        paramDict["password"] = password
        
        if let serviceUrl = URL(string: url) {
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-type")
            
            if let httpBody = try? JSONSerialization.data(withJSONObject: paramDict, options: []) {
                request.httpBody = httpBody
                
                let session = self.createDefaultSession(timeout: 90.0)
                let task = session.synchronousDataTask(with: request)
                if task.2 != nil {
                    
                } else if let data = task.0 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                        if json["access_token"] != nil && json["expiry_timestamp"] != nil {
                            
                            let returnedToken: String = json["access_token"] as! String
                            var tokenValidity = ""
                            
                            if json["expiry_timestamp"] != nil {
                                //  do {
                                if  json["expiry_timestamp"] != nil {
                                    let type = json["expiry_timestamp"]
                                    if type is String {
                                        tokenValidity = type as! String
                                    } else {
                                        let num = type as! NSNumber
                                        tokenValidity = num.stringValue
                                    }
                                    
                                }
                                UserDefaults.standard.set(tokenValidity, forKey: "oneMapTokenValidity")
                            }
                            UserDefaults.standard.set(returnedToken, forKey: "oneMapToken")
                            return returnedToken
                            
                        } else {
                            return UserDefaults.standard.string(forKey: "oneMapToken") ?? ""
                        }
                        
                    } catch let error as NSError {
                        print(error.description)
                    }
                }
                
            }
        }
        
        return ""
    }
    
    ////////////////////////////////////////////////////////////////
    
    //MARK:Reverse Geocode Call
    
    ////////////////////////////////////////////////////////////////
    
    public func getOneMapReverseGeocode(latitude: String, longtitude: String, buffer: String, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url: String = OneMap_API_ReverseGeocode
        
        var paramDict = Dictionary<String, Any>()
        paramDict["buffer"] = buffer
        paramDict["addressType"] = "All"
        paramDict["otherFeatures"] = "N"
        let location = String(format: "%@,%@", latitude, longtitude)
        paramDict["location"] = location
        
        //Add token to param
        let requestParam = self.appendTokenToParam(inputParam: paramDict)
        
        var components = URLComponents(string: url)
        components?.queryItems = requestParam.map { (arg) -> URLQueryItem in
            let (attName, attValue) = arg
            return URLQueryItem(name: attName, value: attValue as? String)
        }
        
        let encodedQuery =  components?.percentEncodedQuery
        components?.percentEncodedQuery = encodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-type")
        
        let session = self.createDefaultSession(timeout: 120.0)
        
        let task = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            if error != nil {
                onFailure(error!)
            } else if let data = data {
                do {
                    // let _ = String(data: data, encoding: String.Encoding.utf8)
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                    onSuccess(json)
                } catch let error as NSError {
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
    
    ////////////////////////////////////////////////////////////////
    
    //MARK:Search Call
    //This API provides searching of address data for a given search value. It returns search results with both latitude, longitude and x, y coordinates of the searched location.
    
    ////////////////////////////////////////////////////////////////
    public func getOneMapSearch(keyword: String, pageNumber: String, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url: String = OneMap_API_Search
        
        var paramDict = Dictionary<String, Any>()
        
        paramDict["searchVal"] = keyword
        paramDict["pageNum"] = pageNumber
        paramDict["returnGeom"] = "Y"
        paramDict["getAddrDetails"] = "Y"
        //Add token to param
        let requestParam = paramDict //self.appendTokenToParam(inputParam: paramDict)
        
        var components = URLComponents(string: url)
        components?.queryItems = requestParam.map { (arg) -> URLQueryItem in
            let (attName, attValue) = arg
            return URLQueryItem(name: attName, value: attValue as? String)
        }
        
        let encodedQuery =  components?.percentEncodedQuery
        components?.percentEncodedQuery = encodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-type")
        
        let session = self.createDefaultSession(timeout: 120.0)
        
        let task = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            if error != nil {
                onFailure(error!)
            } else if let data = data {
                do {
                    //  let _ = String(data: data, encoding: String.Encoding.utf8)
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                    onSuccess(json)
                } catch let error as NSError {
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
    
    public func getOneMapRoute(originLat: String, originLong: String, destinationLat: String, destinationLong: String, routeType: String, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url: String = OneMap_API_Route
        
        var paramDict = Dictionary<String, Any>()
        
        let origin = String(format: "%@,%@", originLat, originLong)
        paramDict["start"] = origin
        let destination = String(format: "%@,%@", destinationLat, destinationLong)
        paramDict["end"] = destination
        
        paramDict["routeType"] = routeType
        //Add token to param
        let requestParam = self.appendTokenToParam(inputParam: paramDict)
        
        var components = URLComponents(string: url)
        components?.queryItems = requestParam.map { (arg) -> URLQueryItem in
            let (attName, attValue) = arg
            return URLQueryItem(name: attName, value: attValue as? String)
        }
        
        let encodedQuery =  components?.percentEncodedQuery
        components?.percentEncodedQuery = encodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-type")
        
        let session = self.createDefaultSession(timeout: 120.0)
        
        let task = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            if error != nil {
                onFailure(error!)
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                    onSuccess(json)
                } catch let error as NSError {
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
    
    public func getRouteForPublicTransportationFromLocation(originLat: String, originLong: String, destinationLat: String, destinationLong: String, routeType: String, startTime: Date, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url: String = OneMap_API_Route
        
        var paramDict = Dictionary<String, Any>()
        
        let origin = String(format: "%@,%@", originLat, originLong)
        paramDict["start"] = origin
        let destination = String(format: "%@,%@", destinationLat, destinationLong)
        paramDict["end"] = destination
        
        paramDict["mode"] = "TRANSIT"
        paramDict["routeType"] = "pt"
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter.init()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let date = dateFormatter.string(from: startTime)
        let time = timeFormatter.string(from: startTime)
        
        paramDict["date"] = date
        paramDict["time"] = time
        //Add token to param
        let requestParam = self.appendTokenToParam(inputParam: paramDict)
        
        var components = URLComponents(string: url)
        components?.queryItems = requestParam.map { (arg) -> URLQueryItem in
            let (attName, attValue) = arg
            return URLQueryItem(name: attName, value: attValue as? String)
        }
        
        let encodedQuery =  components?.percentEncodedQuery
        components?.percentEncodedQuery = encodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-type")
        
        let session = self.createDefaultSession(timeout: 120.0)
        
        let task = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            if error != nil {
                onFailure(error!)
            } else if let data = data {
                do {
                    //   let _ = String(data: data, encoding: String.Encoding.utf8)
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                    onSuccess(json)
                } catch let error as NSError {
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        var disposition: URLSession.AuthChallengeDisposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        
        var credential: URLCredential?
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            if credential != nil {
                disposition = URLSession.AuthChallengeDisposition.useCredential
            } else {
                disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
            }
        } else {
            disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
        }
        
        if credential != nil {
            completionHandler(disposition, credential)
        }
    }
    
    func createDefaultSession(timeout: TimeInterval) -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout
        sessionConfig.timeoutIntervalForResource = timeout
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: self.queue)
        return session
    }
}

extension URLSession {
    func synchronousDataTask(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
