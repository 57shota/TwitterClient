//
//  APIOperator.swift
//  TwitterClientSample
//
//  Created by shota ito on 17/04/2019.
//  Copyright © 2019 shota ito. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol SearchUserApi {
    func getToken(result: @escaping (Result<Bool>) -> ())
    func getTweets(content: String, tweets: @escaping (Result<[Tweet]>) -> ())
}

final class APIOperator: SearchUserApi {
    
     var accessToken: String?
     let tokenApi = "https://api.twitter.com/oauth2/token"
     let api = "https://api.twitter.com/1.1/search/tweets.json"
     let consumerKey = "<your consumerKey>"
     let consumerSecret = "your consumerSecret"
    
    func getToken(result: @escaping (Result<Bool>) -> ()) {
        
        let credentials = "\(consumerKey):\(consumerSecret)".data(using: String.Encoding.utf8)!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let headers = [
            "Authorization" : "Basic \(credentials)",
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
        ]
        let params: [String : AnyObject] = ["grant_type": "client_credentials" as AnyObject]
        
        Alamofire.request(
            tokenApi,
            method: .post,
            parameters: params,
            encoding: URLEncoding.httpBody,
            headers: headers
            )
            .responseJSON { (response) in
                guard let object = response.result.value else {
                    print("Getting token is failed")
                    result(.failure(SessionError.accessError))
                    return
                }
                let json = JSON(object)
                print(json)
                self.accessToken = json["access_token"].string
                result(.success(true))
        }
    }
    
    func getTweets(content: String, tweets: @escaping (Result<[Tweet]>) -> ()) {
        let params = [
            "q" : content,
            "result_type": "recent",
            "count": "15"
        ]
        let headers = [
            "Authorization" : "Bearer \(accessToken!)"
        ]
        
        Alamofire.request(
            api,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: headers)
            .responseJSON { response in
                guard let object = response.result.value else {
                    print("Getting json is failed")
                    return
                }
                print(JSON(object))
                let json = JSON(object)
                var tweetsArray: [Tweet] = []
                guard json["statuses"].count != 0 else {
                    tweets(.failure(SessionError.notFound))
                    return
                }
                for i in 0...json["statuses"].count - 1 {
                    let userName = json["statuses"][i]["user"]["name"].string!
                    let userID =  json["statuses"][i]["user"]["screen_name"].string!
                    let text =  json["statuses"][i]["text"].string!
                    let profImage =  json["statuses"][i]["user"]["profile_image_url"].string!
                    let createdAt = json["statuses"][i]["created_at"].string!
                    let commentCount = String(json["statuses"][i]["entities"]["user_mentions"].count)
                    let retweetCount = String(json["statuses"][i]["retweet_count"].int!)
                    let likeCount = String(json["statuses"][i]["favorite_count"].int!)
                    let tweet: Tweet = Tweet(userName: userName, userID: userID, text: text, createdAt: createdAt, commentCount: commentCount, retweetCount: retweetCount, likeCount: likeCount, profImage: profImage)
                    tweetsArray.append(tweet)
                }
                tweets(.success(tweetsArray))
            }
    }
}
