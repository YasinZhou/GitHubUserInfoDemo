//
//  UserRepoTableViewCell.swift
//  GitHubUserInfoDemo
//
//  Created by Yasin on 11/20/19.
//  Copyright © 2019 Yasin. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserRepoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func updateInfo(json: JSON) {
        nameLabel.text = json["name"].string
        desLabel.text = json["description"].string
        languageLabel.text = json["language"].string
        starLabel.text = "Stars: " + (json["stargazers_count"].string ?? "0")
        forkLabel.text = "Forks: " + (json["forks_count"].string ?? "0")
    }

}
