//
//  Network.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//

import Foundation
import Alamofire

class NetworkUtils{
static func hasInternetConnection() -> Bool {
    return NetworkReachabilityManager(host: "www.google.com")?.isReachable ?? false
    }
}
