//
//  StoredData.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 12.09.2021.
//

import Foundation


class StoredData {
    var movies = [Movie]()
    var tvShows = [TVShow]()
    var cast = [Cast]()
    var selectedItemID: Int?
    var selectedItemIndexPath: Int?
    var selectedContent: SelectedContent?
}
