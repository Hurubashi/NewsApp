//
//  NewsService.swift
//  NewsApp
//
//  Created by Max Rybak on 2/13/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import RxSwift
import RealmSwift

class NewsService {
    
    private let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=c688ec688ceb44fa9023b959a4b2ac8d"
    
    public func fetchNews() -> Observable<[NewsDecodable]> {
        guard let url = URL(string: urlString) else { return Observable.empty() }
        
        let request: Observable<URLRequest> = Observable.create {
            observer in
            let request = URLRequest(url: url)
            observer.onNext(request)
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        return request.flatMap() {
            request in
            return URLSession.shared.rx.response(request: request).map {
                response, data in
                if 200 ..< 300 ~= response.statusCode {
                    let news = try JSONDecoder().decode(NewsWrapper.self, from: data)
                    return news.news
                } else {
                    throw ApiError.wentWrong
                }
            }
        }
    }
    
    func getData(from url: URL) -> Observable<Data> {
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
    }

}
