//
//  extension ContentVC + CollectionView.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 11.09.2021.
//

import Foundation
import UIKit


extension ContentVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func connectCollectionView() {
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedData.cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cast = storedData.cast[indexPath.row]
        let posterPath = URL(string: "http://image.tmdb.org/t/p/w185/" + cast.poster)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCell
        cell.castImageView.layer.cornerRadius = cell.castImageView.frame.height/2
        
        cell.castImageView.kf.setImage(with: posterPath)
        cell.nameLabel.text = cast.name
        cell.characterLabel.text = cast.character
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
