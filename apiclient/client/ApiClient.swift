//
//  ApiClient.swift
//  Umba
//
//  Created by CWG Mobile Dev on 06/01/2022.
//

import Foundation

import Foundation
import Moya
import RxSwift

class ApiClient {
    fileprivate var provider = MoyaProvider<NetworkManager>(plugins: [VerbosePlugin(verbose: true)])
    func getPopularMovies(page: String) -> Observable<MovieResponse> {
        provider.rx.request(.getPopularMovies(page: page)).asObservable().map(MovieResponse.self)
    }
    func getUpcomingMovies(page:String) -> Observable<MovieResponse> {
        provider.rx.request(.getUpcomingMovies(page: page)).asObservable().map(MovieResponse.self)
    }
    func getLatestMovie() -> Observable<MovieDetailResponse> {
        provider.rx.request(.getLatestMovies).asObservable().map(MovieDetailResponse.self)
    }
    func getMovieDetail(movieId: String) -> Observable<MovieDetailResponse> {
        provider.rx.request(.getMovieDetails).asObservable().map(MovieDetailResponse.self)
    }
}
