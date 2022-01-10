//
//  HomeVm.swift
//  Umba
//
//  Created by CWG Mobile Dev on 06/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import CoreData

class HomeVM {
    
    var apiClient = ApiClient()
    let coreDataHelper = CoreDataHelper(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    let hideState =  BehaviorRelay<Bool>(value: true)
    let errorMsgObs =  BehaviorRelay<String>(value: "")
    let networkErrorSubject = BehaviorRelay<String>(value: "")
    
    var popularMoviesSubject = PublishSubject<MovieResponse>()
    var disposeBag = DisposeBag()
    var upcomingMoviesSubject = PublishSubject<MovieResponse>()
    var latestMovieSubject = PublishSubject<MovieDetailResponse>()
    
    
    func getPopularModel(page:String){
        if !NetworkUtils.hasInternetConnection() {
            networkErrorSubject.accept("Network Error")
            return
        }
        apiClient.getPopularMovies(page: page).asObservable().subscribe(onNext: {[self]
            result in
            if result !=  nil{
            self.popularMoviesSubject.onNext(result)
            }
            coreDataHelper.saveMovies(movies: result.results!, name: "popular")
        }) { error in
            //errors will be handles as Moya Error
        }.disposed(by: disposeBag)
    }
    
    func getUpcomingMovies(page: String){
        if !NetworkUtils.hasInternetConnection() {
            networkErrorSubject.accept("Network Error")
            return
        }
        apiClient.getUpcomingMovies(page: page).asObservable().subscribe(onNext: {[self]
            result in
            if result !=  nil{
            self.upcomingMoviesSubject.onNext(result)
            }
            coreDataHelper.saveMovies(movies: result.results!, name: "upcoming")
        }) { error in
            //errors will be handles as Moya Error
        }.disposed(by: disposeBag)
    }
    func getLatestMovie(){
        if !NetworkUtils.hasInternetConnection() {
            networkErrorSubject.accept("Network Error")
            return
        }
        apiClient.getLatestMovie().asObservable().subscribe(onNext: {
            result in
            self.latestMovieSubject.onNext(result)
        }) { error in
            //errors will be handles as Moya Error
        }.disposed(by: disposeBag)
    }
    func getSavedMovies(name: String){
        let mvResponse =  coreDataHelper.getSavedMovies(name: name)
        if mvResponse != nil{
            switch name {
            case "upcoming":
                upcomingMoviesSubject.onNext(mvResponse!)
            case "popular":
                popularMoviesSubject.onNext(mvResponse!)
            default:
                break
            }
        }
    }
    
    
}
