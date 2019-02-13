//
//  News.swift
//  NewsApp
//
//  Created by Max Rybak on 2/13/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import Foundation

struct NewsDecodable : Decodable {
    
    let news : [News]
    
    enum CodingKeys : String, CodingKey {
        case news = "articles"
    }
}

struct News : Decodable {
    let title : String?
    let description : String?
    let content: String?
    let url : URL?
    let urlToImage: URL?
}
