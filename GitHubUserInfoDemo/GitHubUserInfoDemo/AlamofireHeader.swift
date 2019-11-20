//
//  AlamofireHeader.swift
//  GitHubUserInfoDemo
//
//  Created by Yasin on 11/20/19.
//  Copyright © 2019 Yasin. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireHeader: NSObject {

    public static func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        var header = HTTPHeaders()
        let userDefaults = UserDefaults.standard
        if let token = userDefaults.value(forKey: "token") as? String {
            if headers != nil {
                header = headers!
            }
            header["Authorization"] = token;
        }
        return Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: header)
        
    }
}
