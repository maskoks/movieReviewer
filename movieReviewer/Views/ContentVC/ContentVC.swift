//
//  ContentVC.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 09.09.2021.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher
import SafariServices
import Cosmos

class ContentVC: UIViewController {
    
    var storedData: StoredData!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var parametersLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var watchNowButton: UIButton!
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        topView.addSubview(posterImageView)
        connectCollectionView()
        setContentToViews()
        castRequest {
            self.castCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setBookmarkImage()
        addGradient()
        animations()
        watchNowButton.layer.cornerRadius = 15
    }

    func provideData(storedData: StoredData) {
        self.storedData = storedData
    }
    
    func animations() {
        UIView.animate(withDuration: 0.5) {
            self.posterImageView.widthAnchor.constraint(equalTo: self.topView.widthAnchor).isActive = true
            self.posterImageView.heightAnchor.constraint(equalTo: self.topView.heightAnchor).isActive = true
            self.posterImageView.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor).isActive = true
            self.posterImageView.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor, constant: 0).isActive = true
            self.topView.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5, delay: 0.4) {
            self.topView.bringSubviewToFront(self.titleStackView)
            self.topView.bringSubviewToFront(self.buttonsStackView)
            self.titleStackView.alpha = 1
            self.buttonsStackView.alpha = 1
        }
        UIView.animate(withDuration: 0.5, delay: 0.7) {
            self.ratingStackView.alpha = 1
            self.descriptionTextView.alpha = 1
            self.castLabel.alpha = 1
            self.castCollectionView.alpha = 1
        }
    }

    func addGradient() {
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor(named: "defaultBackgroundColor")!.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame.size = topView.frame.size
        topView.layer.addSublayer(gradientLayer)
    }
    
    func setContentToViews() {
        let content = storedData.selectedContent
        let posterPath = URL(string: "http://image.tmdb.org/t/p/original" + content!.poster)
        
        titleLabel.text = content?.name
        ratingLabel.text = String(content!.rating)
        starsView.rating = content!.rating/2
        descriptionTextView.text = content?.description
        posterImageView.kf.setImage(with: posterPath)
        
        switch storedData.selectedContent?.category {
            case .movie:
                parametersLabel.text = "\(content?.otherParametrs ?? "0") minutes"
            case .tv:
                parametersLabel.text = "Number of seasons: \(content?.otherParametrs ?? "0")"
            case .none:
                print("error")
        }
    }
    
    func castRequest(completion: (()->Void)? = nil) {
        
        let url = "https://api.themoviedb.org/3/\( storedData.selectedContent!.category)/\(storedData.selectedItemID!)/credits?api_key=cbb8608d77f0c5ec67b400fe498973c7"
        AF.request(url, method: .get).validate().responseData { [self] (response ) in
            switch response.result {
            
            case .success(_):
                guard let data = response.data else { return }
                guard let json = try? JSON(data: data) else { return }
                let castJSON = json["cast"]
                self.storedData.cast = castJSON.arrayValue.compactMap {Cast(json: $0)}
                completion?()
         
            case .failure(let error):
                presentAlert()
                print(error.localizedDescription)
            }
        }
    }
    
    func setBookmarkImage() {
        let isFavouriteImage = UIImage(systemName: "bookmark.fill")
        let isNotFavouriteImage = UIImage(systemName: "bookmark")
        
        switch storedData.selectedContent?.category {
        
        case .movie:
            storedData.movies[storedData.selectedItemIndexPath!].isFavorite ? bookmarkButton.setImage(isFavouriteImage, for: .normal) : bookmarkButton.setImage(isNotFavouriteImage, for: .normal)
        case .tv:
            storedData.tvShows[storedData.selectedItemIndexPath!].isFavorite ? bookmarkButton.setImage(isFavouriteImage, for: .normal) : bookmarkButton.setImage(isNotFavouriteImage, for: .normal)
        case .none:
            print("error")
        }
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "К сожалению, мы не знаем, кто тут играет:(", message: nil, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAlertAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookmarkButtonAction(_ sender: Any) {
        switch storedData.selectedContent?.category {
        
        case .movie:
            storedData.movies[storedData.selectedItemIndexPath!].isFavorite.toggle()
        case .tv:
            storedData.tvShows[storedData.selectedItemIndexPath!].isFavorite.toggle()
        case .none:
            print("error")
        }
        setBookmarkImage()
    }
    
    @IBAction func watchNowButtonAction(_ sender: Any) {
        let url = URL(string: storedData.selectedContent!.homepage)
        let safariVC = SFSafariViewController(url: url!)
        present(safariVC, animated: true)
    }
    
}

