//
//  ViewController.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 09.09.2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainVC: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var tvShowCollectionView: UICollectionView!
    
    var storedData = StoredData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesRequest(completion: movieCollectionView.reloadData)
        tvShowsRequest(completion: tvShowCollectionView.reloadData)
        connectCollectionViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
        setUpSearchButton()
    }
    
    
    func setUpSearchButton() {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        rightButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        rightButton.tintColor = .white
        rightButton.addTarget(self, action: #selector(searchButton), for: .touchUpInside)
        navigationController?.navigationBar.addSubview(rightButton)

        let targetView = self.navigationController?.navigationBar
        let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
            .trailingMargin, relatedBy: .equal, toItem: targetView,
                             attribute: .trailingMargin, multiplier: 1.0, constant: -15)
        let bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal,
                                        toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -15)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
    }
    
    @objc func searchButton() {
        print("На эту кнопку я кидал тесты. Она работает")
    }
    
    func presentContentVC() {
        guard let contentVC = storyboard?.instantiateViewController(identifier: "ContentVC") as? ContentVC else { return }
        contentVC.modalPresentationStyle = .fullScreen
        contentVC.provideData(storedData: storedData)
        navigationController?.pushViewController(contentVC, animated: true)
    }
    
    func dateFormatter(from date: String) -> String {
        let date1Formatter = DateFormatter()
        date1Formatter.dateFormat = "yyyy-MM-dd"
        guard let date1 = date1Formatter.date(from: date) else { return "error" }
        
        let date2Formatter = DateFormatter()
        date2Formatter.dateFormat = "MMM d, yyyy"
        let convertDate = date2Formatter.string(from: date1)
        return convertDate
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Ошибка сети:( кина не будет", message: nil, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAlertAction)
        present(alert, animated: true, completion: nil)
    }
}

