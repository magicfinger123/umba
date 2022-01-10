//
//  CoreDataHelper.swift
//  Umba
//
//  Created by CWG Mobile Dev on 09/01/2022.
//

import Foundation
import CoreData



class CoreDataHelper{
    var context: NSManagedObjectContext
    init(context: NSManagedObjectContext){
        self.context = context
    }
    func saveMovies(movies:[Movie], name:String){
        let movieGroup = MovieGroup(context: context)
        movieGroup.name = name
        del(name: name)
        for movie in movies {
            let movieEntity = MovieEntity(context: context)
            movieEntity.movieGroup = movieGroup
            movieEntity.posterPath = movie.posterPath
            movieEntity.backdropPath = movie.posterPath
            movieEntity.title = movie.title
            movieEntity.overview = movie.overview
            movieEntity.originalTitle = movie.originalTitle
            movieEntity.originalLanguage = movie.originalLanguage
            movieEntity.releaseDate = movie.releaseDate
            movieEntity.voteCount = movie.voteCount!
            movieEntity.voteAverage = movie.voteAverage!
            movieEntity.video = movie.video!
            movieEntity.adult = movie.adult!
            movieEntity.popularity = movie.popularity!
            movieEntity.id = Int64(movie.id!)
            movieGroup.addToGroup(movieEntity)
        }
        do {
            try context.save()
            print(" coredata context: saved")
        }catch {
            let nserror = error as NSError
            fatalError("coredata error \(nserror), \(nserror.userInfo)")
        }
    }
    func del(name: String){
        var movieGroups: [MovieEntity]
        do{
            let request = MovieEntity.fetchRequest() as NSFetchRequest<MovieEntity>
            let pred = NSPredicate(format: "movieGroup.name CONTAINS '\(name)'")
            request.predicate = pred
            movieGroups =  try context.fetch(request)
            for movieGroup in movieGroups {
                context.delete(movieGroup)
            }
        } catch{
            let nserror = error as NSError
            fatalError("coredata error \(nserror), \(nserror.userInfo)")
        }
    }
    func getSavedMovies(name: String)-> MovieResponse?{
        var movieEntities: [MovieEntity]
        var movies: [Movie] = []
        do {
            let request = MovieEntity.fetchRequest() as NSFetchRequest<MovieEntity>
           let pred = NSPredicate(format: "movieGroup.name CONTAINS '\(name)'")
           request.predicate = pred
            movieEntities =  try context.fetch(request)
            for movieEntity in movieEntities {
                var movie = Movie()
                print("group: \(movieEntity.movieGroup?.name)")
                movie.posterPath = movieEntity.backdropPath
                movie.title = movieEntity.title
                movie.overview =  movieEntity.overview
                movie.originalTitle = movieEntity.originalTitle
                movie.originalLanguage = movieEntity.originalLanguage
                movie.releaseDate = movieEntity.releaseDate
                movie.voteCount = movieEntity.voteCount
                movie.voteAverage =  movieEntity.voteAverage
                movie.video =  movieEntity.video
                movie.adult = movieEntity.adult
                movie.popularity = movieEntity.popularity
                movie.id =  Int(movieEntity.id)
                movies.append(movie)
            }
            var mvResponse = MovieResponse()
            mvResponse.results = movies
//            switch name {
//            case "upcoming":
//                upcomingMoviesSubject.onNext(mvResponse)
//            case "popular":
//                popularMoviesSubject.onNext(mvResponse)
//            default:
//                break
//            }
            return mvResponse
        }catch {
        }
        return nil
    }

}
