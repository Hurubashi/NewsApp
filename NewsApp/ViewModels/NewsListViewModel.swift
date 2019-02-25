//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Max Rybak on 2/13/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

class NewListViewModel {

    private let newsService: NewsService
    private let bag = DisposeBag()
    private let realm = try! Realm()
    
    let news = BehaviorRelay<[News]>(value: [])
    let error = BehaviorRelay<ApiError?>(value: nil)
    
    init() {
        
        newsService         = NewsService()
        let newsFetcher     = newsService.fetchNews().share(replay: 1)
        
        Observable.array(from: realm.objects(News.self)).bind(to: news).disposed(by: bag)
        
        newsFetcher.observeOn(MainScheduler.asyncInstance)
        .subscribe(
            onNext: { [weak self] newsDecodable in
                    self?.deleteOldRealmData()
                    self?.saveNews(with: newsDecodable)
                        for elem in newsDecodable {
                            if let url = URL(string: elem.urlToImage ?? "") {
                                self?.newsService.getData(from: url).observeOn(MainScheduler.asyncInstance).subscribe {
                                    data in
                                    if let title = elem.title , let data = data.element{
                                        self?.updataNewsImage(for: title, with: data)
                                    }
                                    }
                                    .disposed(by: self?.bag ?? DisposeBag())
                            }
                        }
            },
            onError: { [weak self] error in
                if let castedError = error as? ApiError{
                    self?.error.accept(castedError)
                } else {
                    self?.error.accept(ApiError.noConnection)
                }
            })
        .disposed(by: bag)
        
    }
    
    // MARK: - Realm DB handling functions
    func saveNews(with newsDecodable: [NewsDecodable]) {
        for elem in newsDecodable {
            let newsElem = News()
            newsElem.fillIt(with: elem)
            do {
                try realm.write {
                    realm.add(newsElem)
                }
            } catch {
                print("Error saving \(error)")
            }
        }
    }
    
    func updataNewsImage(for title: String, with data: Data) {
        let newsByTitle = realm.objects(News.self).filter("title = %@", title)
        
        if let elem = newsByTitle.first {
            try! realm.write {
                print("lalal")
                elem.image = data
            }
        }
    }
    
    func deleteOldRealmData() {
        let data = realm.objects(News.self)
        do {
            try realm .write {
                realm.delete(data)
            }
        } catch {
            print("Error deleting \(error)")
        }
    }
    
}

