//
//  MovieEntity+CoreDataProperties.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var id: Int64
    @NSManaged public var posterPath: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Double
    @NSManaged public var popularity: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var video: Bool
    @NSManaged public var movieGroup: MovieGroup?

}

extension MovieEntity : Identifiable {

}
