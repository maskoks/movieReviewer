//
//  extension MainVC + CollectionView.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 09.09.2021.
//

import Foundation
import UIKit
import Kingfisher

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func connectCollectionViews() {
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(nib, forCellWithReuseIdentifier: "CustomCell")
        
        tvShowCollectionView.delegate = self
        tvShowCollectionView.dataSource = self
        tvShowCollectionView.register(nib, forCellWithReuseIdentifier: "CustomCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.movieCollectionView {
            return storedData.movies.count
        } else {
            return storedData.tvShows.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.movieCollectionView {
            let movies = storedData.movies[indexPath.row]
            let posterPath = URL(string: "http://image.tmdb.org/t/p/w185/"+movies.poster)
            let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
            movieCell.contentImageView.kf.setImage(with: posterPath)
            movieCell.titleLabel.text = movies.title
            movieCell.dateLabel.text = dateFormatter(from: movies.date)
            return movieCell
        } else {
            let tvShows = storedData.tvShows[indexPath.row]
            let posterPath = URL(string: "http://image.tmdb.org/t/p/w185/"+tvShows.poster)
            let tvShowCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
            tvShowCell.contentImageView.kf.setImage(with: posterPath)
            tvShowCell.titleLabel.text = tvShows.title
            tvShowCell.dateLabel.text = dateFormatter(from: tvShows.date)
            return tvShowCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        storedData.selectedItemIndexPath = indexPath.row
        
        if collectionView == self.movieCollectionView {
            storedData.selectedItemID = storedData.movies[indexPath.row].id
            selectedMovieRequest {
                self.presentContentVC()
            }
        } else {
            storedData.selectedItemID = storedData.tvShows[indexPath.row].id
            selectedTvShowRequest {
                self.presentContentVC()
            }
        }
    }
}


