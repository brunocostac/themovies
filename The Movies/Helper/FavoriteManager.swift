//
//  FavoriteManager.swift
//  The Movies
//
//  Created by Bruno Costa on 01/02/23.
//

import Foundation
import CoreData
import UIKit


enum FavoriteManagerError: Equatable, Error {
    case CannotSave(String = "Não foi possível salvar o filme nos favoritos. Tente novamente.")
    case CannotFind(String = "O filme não foi encontrado.")
    case CannotRemove(String = "Não foi possível remover o filme. Tente novamente.")
    case CannotFetch(String = "Não foi possível obter a lista de filmes.")
}


class FavoriteManager {

    func save(movie: Movie, completion: @escaping (Movie?, FavoriteManagerError?) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(nil, FavoriteManagerError.CannotSave())
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let favorite = Favorite(context: managedContext)

        favorite.setValue(movie.id, forKey: "id")
        favorite.setValue(movie.overview, forKey: "overview")
        favorite.setValue(movie.poster_path, forKey: "poster_path")
        favorite.setValue(movie.release_date, forKey: "release_date")
        favorite.setValue(movie.title, forKey: "title")

        do {
            try managedContext.save()
            completion(movie, nil)
        } catch {
            completion(nil, FavoriteManagerError.CannotSave())
        }
    }
    
    
    func fetch(movie: Movie, completion: @escaping (Movie?,FavoriteManagerError?) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(nil, FavoriteManagerError.CannotSave())
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
       
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if fetchedResults.first != nil {
                completion(movie, nil)
            } else {
                completion(nil, FavoriteManagerError.CannotFind())
            }
        } catch {
            completion(nil, FavoriteManagerError.CannotSave())
        }
    }
    
    func fetchAll(search: String = "", completion: @escaping ([Movie]?, FavoriteManagerError?) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(nil, FavoriteManagerError.CannotSave())
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")

        if !search.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", search)
        }

        do {
            let count = try managedContext.count(for: fetchRequest)

            let fetchedResults = try managedContext.fetch(fetchRequest)
            var movies = [Movie]()
            
            for result in fetchedResults {
                movies.append(Movie(poster_path: result.poster_path ?? "", overview: result.overview ?? "", release_date: result.release_date ?? "", original_title: "", title: result.title ?? "" , id: Int(result.id), genre_ids: []))
            }

            completion(movies, nil)
        } catch {
            completion(nil, FavoriteManagerError.CannotSave())
        }
    }
    
    
    func remove(movie: Movie, completion: @escaping (Movie?, FavoriteManagerError?) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(nil, FavoriteManagerError.CannotRemove())
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if let result = fetchedResults.first {
                managedContext.delete(result)
                try managedContext.save()
                completion(movie, nil)
            } else {
                completion(nil, FavoriteManagerError.CannotRemove())
            }
        } catch {
            completion(nil, FavoriteManagerError.CannotRemove())
        }
    }
}
