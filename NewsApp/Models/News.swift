//
//  News.swift
//  NewsApp
//
//  Created by Max Rybak on 2/13/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

struct NewsWrapper : Decodable {

    let news : [NewsDecodable]

    enum CodingKeys : String, CodingKey {
        case news = "articles"
    }
}

struct NewsDecodable : Decodable {
    let title: String?
    let description: String?
    let content: String?
    let url: String?
    let urlToImage: String?
}

class News: Object {
    @objc dynamic var title: String        = ""
    @objc dynamic var shortContent: String = ""
    @objc dynamic var content: String      = ""
    @objc dynamic var url: String          = ""
    @objc dynamic var image: Data          = Data()

    func fillIt(with news: NewsDecodable) {
        title        = news.title ?? ""
        shortContent = news.description ?? ""
        content      = news.content ?? ""
        url          = news.url ?? ""
    }
}
