//
//  NewsDetailVC.swift
//  NewsApp
//
//  Created by Max Rybak on 2/25/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import UIKit

class NewsDetailVC: UIViewController {

    var news: News!
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(data: news.image) {
            newsImage.image = image
        }
        newsLabel.text = news.content
    }
    
}
