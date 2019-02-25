//
//  NewsCell.swift
//  NewsApp
//
//  Created by Max Rybak on 2/13/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    func initCell(with news: News) {
        title.text = news.title
        newsDescription.text = news.shortContent
        newsImg.image = UIImage(data: news.image)
    }
    
}
