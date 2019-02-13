//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Max Rybak on 2/13/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import RxSwift
import RxCocoa

class NewListViewModel {

    private let newsService: NewsService
    
    let news: Observable<[News]>
    
    init() {
        newsService = NewsService()
        news = newsService.fetchNews()
    }
}
