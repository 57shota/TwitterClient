//
//  SearchPresenter.swift
//  TwitterClientSample
//
//  Created by shota ito on 17/04/2019.
//  Copyright © 2019 shota ito. All rights reserved.
//

import Foundation
import UIKit

protocol SearchPresenterInput {
    var numberOfTweet: Int {get}
    func tweet(forRow row: Int) -> Tweet?
    func didTapSearchButton(text: String?)
    func didScroll()
}

protocol SearchPresenterOutput: AnyObject {
    func updateTweets(_ tweets: [Tweet])
    func displayErrorAlert(alert: UIAlertController)
}

enum loadStatus {
    case initial
    case loading
    case loadMore
    case done
    case error
}

final class SearchPresenter: SearchPresenterInput {
    
    private var api: SearchUserApi
    private weak var view: SearchPresenterOutput!
    private let errorHandller: ErrorHandller!
    private var tweets: [Tweet] = []
    private var query: String = ""
    private var currentStatus = loadStatus.initial

    init(api: SearchUserApi, view: SearchPresenterOutput, errorHandller: ErrorHandller) {
        self.api = api
        self.view = view
        self.errorHandller = errorHandller
    }
    
    var numberOfTweet: Int {
        return tweets.count
    }
    
    func tweet(forRow row: Int) -> Tweet? {
        guard row < tweets.count else {return nil}
        return tweets[row]
    }
    
    func didScroll() {
        guard currentStatus != .loading && currentStatus != .done else {return}
        currentStatus = .loading
        
        api.getTweets(content: query) { [weak self] (result) in
            switch result {
            case .success(let tweets):
                if tweets.count == 0 {
                    self?.currentStatus = .done
                    return
                }                
                self?.tweets += tweets
                self?.view.updateTweets(self!.tweets)
                self?.currentStatus = .loadMore
                
            case .failure(let error):
                print("Error: cannot find tweets")
                self?.view.displayErrorAlert(alert: self!.errorHandller.notFoundAlert)
                self?.currentStatus = .error
            }
        }
    }
    
    func didTapSearchButton(text: String?) {
        
        guard let searchQuery = text else {return}
        guard !searchQuery.isEmpty else {
            view.displayErrorAlert(alert: errorHandller.blankSearchAlert)
            return
        }
        query = searchQuery

        api.getToken() { [weak self] result in
            switch result {
            case .success(let fine):
                self!.api.getTweets(content: searchQuery) { [weak self] result in
                    switch result {
                    case .success(let tweets):
                        self?.tweets = tweets
                        self?.view.updateTweets(self!.tweets)
                        
                    case .failure(let error):
                        print("Error: cannot find tweets")
                        self?.view.displayErrorAlert(alert: self!.errorHandller.notFoundAlert)
                        self?.currentStatus = .error
                    }
                }
            case .failure(let error):
                print("Error: cannot call getTweets()")
                self?.view.displayErrorAlert(alert: self!.errorHandller.accessErrorAlert)
                self?.currentStatus = .error
            }
        }
    }
}


