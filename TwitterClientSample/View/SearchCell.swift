//
//  SearchCell.swift
//  TwitterClientSample
//
//  Created by shota ito on 17/04/2019.
//  Copyright © 2019 shota ito. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconUISetting()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
    
    func configure(tweet: Tweet) {
        userNameLabel.text = tweet.userName
        userIDLabel.text = "@\(tweet.userID)"
        descLabel.text = tweet.text
        let formattedTime = dateFormatter.date(from: tweet.createdAt)?.timeAgoDisplay()
        createdAtLabel.text = formattedTime
        commentCountLabel.text = tweet.commentCount
        retweetCountLabel.text = tweet.retweetCount
        likeCountLabel.text = tweet.likeCount
        iconImageView.af_setImage(withURL: URL(string: tweet.profImage)!)
    }
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()
    
    func iconUISetting() {
        self.iconImageView.clipsToBounds = true
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2.0
        self.iconImageView.layer.borderColor = UIColor.white.cgColor
        self.iconImageView.layer.borderWidth = 1.0
    }
}
