//
//  Requests.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 12.09.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

extension MainVC {

        func moviesRequest(completion: (()->Void)? = nil) {
            let allMoviesURL = "https://api.themoviedb.org/3/discover/movie?api_key=cbb8608d77f0c5ec67b400fe498973c7&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
            AF.request(allMoviesURL, method: .get).validate().responseData { (response ) in
                switch response.result {
                
                case .success(_):
                    guard let data = response.data else { return }
                    guard let json = try? JSON(data: data) else { return }
                    let moviesJSON = json["results"]
                    self.storedData.movies = moviesJSON.arrayValue.compactMap {Movie(json: $0)}
                    completion?()
              
                case .failure(let error):
                    self.presentAlert()
                    print(error.localizedDescription)
                }
            }
        }
        
    func tvShowsRequest(completion: (()->Void)? = nil) {
            let allTVShowsURL = "https://api.themoviedb.org/3/discover/tv?api_key=cbb8608d77f0c5ec67b400fe498973c7&language=en-US&sort_by=popularity.desc&page=1&timezone=America%2FNew_York&include_null_first_air_dates=false&with_watch_monetization_types=flatrate"
            AF.request(allTVShowsURL, method: .get).validate().responseData { (response ) in
                switch response.result {
                
                case .success(_):
                    guard let data = response.data else { return }
                    guard let json = try? JSON(data: data) else { return }
                    let tvShowsJSON = json["results"]
                    self.storedData.tvShows = tvShowsJSON.arrayValue.compactMap {TVShow(json: $0)}
                    print(self.storedData)
                    completion?()
              
                case .failure(let error):
                    self.presentAlert()
                    print(error.localizedDescription)
                }
            }
        }
    
    
    
    func selectedMovieRequest(completion: (()->Void)? = nil) {
        
        let url = "https://api.themoviedb.org/3/movie/\(storedData.selectedItemID!)?api_key=cbb8608d77f0c5ec67b400fe498973c7"
        AF.request(url, method: .get).validate().responseData { [self] (response ) in
            switch response.result {
            
            case .success(_):
                guard let data = response.data else { return }
                guard let json = try? JSON(data: data) else { return }
                guard let unwrID = json["id"].int else { return }
                guard let unwrTitle = json["original_title"].string else { return }
                guard let unwrPoster = json["poster_path"].string else { return }
                guard let unwrOverview = json["overview"].string else { return }
                guard let unwrHomepage = json["homepage"].string else { return }
                guard let unwrRuntime = json["runtime"].int else { return }
                guard let unwrRating = json["vote_average"].double else { return }
                
                self.storedData.selectedContent = SelectedContent(category: .movie, id: unwrID, name: unwrTitle, otherParametrs: String(unwrRuntime), description: unwrOverview, homepage: unwrHomepage, poster: unwrPoster, rating: unwrRating, isFavorite: storedData.movies[storedData.selectedItemIndexPath!].isFavorite)
                completion?()
                
            case .failure(let error):
                self.presentAlert()
                print(error.localizedDescription)
            }
        }
        
    }
    
    func selectedTvShowRequest(completion: (()->Void)? = nil) {
        
        let url = "https://api.themoviedb.org/3/tv/\(storedData.selectedItemID!)?api_key=cbb8608d77f0c5ec67b400fe498973c7&language=en-US"
        AF.request(url, method: .get).validate().responseData { [self] (response ) in
            switch response.result {
            
            case .success(_):
                guard let data = response.data else { return }
                guard let json = try? JSON(data: data) else { return }
                guard let unwrID = json["id"].int else { return }
                guard let unwrTitle = json["name"].string else { return }
                guard let unwrPoster = json["poster_path"].string else { return }
                guard let unwrOverview = json["overview"].string else { return }
                guard let unwrHomepage = json["homepage"].string else { return }
                guard let unwrSeasons = json["number_of_seasons"].int else { return }
                guard let unwrRating = json["vote_average"].double else { return }
                
                
                self.storedData.selectedContent = SelectedContent(category: .tv, id: unwrID, name: unwrTitle, otherParametrs: String(unwrSeasons), description: unwrOverview, homepage: unwrHomepage, poster: unwrPoster, rating: unwrRating, isFavorite: storedData.tvShows[storedData.selectedItemIndexPath!].isFavorite)
                completion?()
                
            case .failure(let error):
                self.presentAlert()
                print(error.localizedDescription)
            }
        }
    }
}
