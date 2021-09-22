//
//  ErrorVC.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 22.09.2021.
//

import UIKit

class ErrorVC: UIViewController {

    @IBOutlet weak var retryButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        retryButton.layer.cornerRadius = 15
    }

    @IBAction func retryButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
