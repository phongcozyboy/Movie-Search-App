//
//  CoreDataManager.swift
//  MovieSearchApp
//
//  Created by Phong Le on 16/06/2021.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init () {}
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createMovie(movie: Movie) {
        let newMovie = MovieDatabase(context: self.context)
        
        newMovie.title = movie.title
        newMovie.posterPath = movie.posterPath
        newMovie.releaseDate = movie.releaseDate
        
        try! self.context.save()
        print("added movie success!")
    }
    
    func getMovies() -> [MovieDatabase]? {
        do {
            let request = MovieDatabase.fetchRequest() as NSFetchRequest<MovieDatabase>
            
            let movies = try context.fetch(request)
            
            return movies
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func deleteMovie(movie: MovieDatabase) {
        self.context.delete(movie)
        
        try! self.context.save()
        print("deleted movie success")
    }
}
