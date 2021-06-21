//
//  MovieDatabase+CoreDataProperties.swift
//  MovieSearchApp
//
//  Created by Phong Le on 16/06/2021.
//
//

import Foundation
import CoreData


extension MovieDatabase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDatabase> {
        return NSFetchRequest<MovieDatabase>(entityName: "MovieDatabase")
    }

    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?

}

extension MovieDatabase : Identifiable {

}
