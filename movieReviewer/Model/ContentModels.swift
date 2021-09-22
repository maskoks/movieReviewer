//
//  ContentModels.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 12.09.2021.
//

import Foundation
import SwiftyJSON

struct Movie {
    let id: Int
    let title: String
    let poster: String
    let date: String
    var isFavorite = false
    
    init?(json: JSON) {
        guard let unwrID = json["id"].int else { return nil }
        guard let unwrTitle = json["original_title"].string else { return nil }
        guard let unwrPoster = json["poster_path"].string else { return nil }
        guard let unwrDate = json["release_date"].string else { return nil }
        
        self.id = unwrID
        self.title = unwrTitle
        self.poster = unwrPoster
        self.date = unwrDate
    }
}

struct TVShow {
    let id: Int
    let title: String
    let poster: String
    let date: String
    var isFavorite = false
    
    init?(json: JSON) {
        guard let unwrID = json["id"].int else { return nil }
        guard let unwrTitle = json["name"].string else { return nil }
        guard let unwrPoster = json["poster_path"].string else { return nil }
        guard let unwrDate = json["first_air_date"].string else { return nil }
        
        self.id = unwrID
        self.title = unwrTitle
        self.poster = unwrPoster
        self.date = unwrDate
    }
}

struct Cast {
    let poster: String
    let name: String
    let character: String
    
    init?(json: JSON) {
        
        guard let unwrPoster = json["profile_path"].string else { return nil }
        guard let unwrName = json["name"].string else { return nil }
        guard let unwrCharacter = json["character"].string else { return nil }
        
        self.poster = unwrPoster
        self.name = unwrName
        self.character = unwrCharacter
    }
}

struct SelectedContent {
    var category: Categories
    var id: Int
    var name: String
    var otherParametrs: String
    var description: String
    var homepage: String
    var poster: String
    var rating: Double
    var isFavorite: Bool
}

enum Categories: String {
    case movie
    case tv
}
