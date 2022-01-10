//
//  NetworkManager.swift
//  Umba
//
//  Created by CWG Mobile Dev on 05/01/2022.
//

import Foundation
import Moya
import Alamofire



enum NetworkManager  {
    case getLatestMovies
    case getPopularMovies(page: String)
    case getUpcomingMovies(page:String)
    case getMovieDetails
}
extension NetworkManager : TargetType{
    var baseURL: URL {
        URL(string: AppUrls.BASE_URL)!
    }
    
    var path: String {
        switch self{
        case .getLatestMovies:
            return AppUrls.LATEST_MOVIES
        case .getPopularMovies:
            return AppUrls.POPULAR_MOBIES
        case .getUpcomingMovies:
            return AppUrls.UPCOMING_MOVIES
        case .getMovieDetails:
            return AppUrls.MOVIE_DETAILS
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self{
        case .getLatestMovies:
            return .requestPlain
        case .getPopularMovies(page: let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding(destination: .queryString, arrayEncoding: .noBrackets))
        case .getUpcomingMovies(page: let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding(destination: .queryString, arrayEncoding: .noBrackets))
        case .getMovieDetails:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept":"application/json",
            "Authorization": AppConstant.BEARER_TOKEN
        ]
    }
    
}

