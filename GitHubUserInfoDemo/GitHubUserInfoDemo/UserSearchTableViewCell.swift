//
//  UserSearchTableViewCell.swift
//  GitHubUserInfoDemo
//
//  Created by Yasin on 11/19/19.
//  Copyright © 2019 Yasin. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

/*
 {
 "html_url" : "https:\/\/github.com\/yaraki",
 "site_admin" : false,
 "starred_url" : "https:\/\/api.github.com\/users\/yaraki\/starred{\/owner}{\/repo}",
 "score" : 55.47587,
 "login" : "yaraki",
 "repos_url" : "https:\/\/api.github.com\/users\/yaraki\/repos",
 "node_id" : "MDQ6VXNlcjEyMzc1MzY=",
 "id" : 1237536,
 "gists_url" : "https:\/\/api.github.com\/users\/yaraki\/gists{\/gist_id}",
 "gravatar_id" : "",
 "avatar_url" : "https:\/\/avatars3.githubusercontent.com\/u\/1237536?v=4",
 "organizations_url" : "https:\/\/api.github.com\/users\/yaraki\/orgs",
 "type" : "User",
 "following_url" : "https:\/\/api.github.com\/users\/yaraki\/following{\/other_user}",
 "received_events_url" : "https:\/\/api.github.com\/users\/yaraki\/received_events",
 "events_url" : "https:\/\/api.github.com\/users\/yaraki\/events{\/privacy}",
 "subscriptions_url" : "https:\/\/api.github.com\/users\/yaraki\/subscriptions",
 "url" : "https:\/\/api.github.com\/users\/yaraki",
 "followers_url" : "https:\/\/api.github.com\/users\/yaraki\/followers"
 }
 */

/*
 {
 "login": "yaraki",
 "id": 1237536,
 "node_id": "MDQ6VXNlcjEyMzc1MzY=",
 "avatar_url": "https://avatars3.githubusercontent.com/u/1237536?v=4",
 "gravatar_id": "",
 "url": "https://api.github.com/users/yaraki",
 "html_url": "https://github.com/yaraki",
 "followers_url": "https://api.github.com/users/yaraki/followers",
 "following_url": "https://api.github.com/users/yaraki/following{/other_user}",
 "gists_url": "https://api.github.com/users/yaraki/gists{/gist_id}",
 "starred_url": "https://api.github.com/users/yaraki/starred{/owner}{/repo}",
 "subscriptions_url": "https://api.github.com/users/yaraki/subscriptions",
 "organizations_url": "https://api.github.com/users/yaraki/orgs",
 "repos_url": "https://api.github.com/users/yaraki/repos",
 "events_url": "https://api.github.com/users/yaraki/events{/privacy}",
 "received_events_url": "https://api.github.com/users/yaraki/received_events",
 "type": "User",
 "site_admin": false,
 "name": "Yuichi Araki",
 "company": "Google, Inc.",
 "blog": "",
 "location": "Tokyo",
 "email": null,
 "hireable": null,
 "bio": null,
 "public_repos": 20,
 "public_gists": 33,
 "followers": 1076,
 "following": 10,
 "created_at": "2011-12-03T04:49:34Z",
 "updated_at": "2019-11-11T05:12:23Z"
 }
 */

class UserSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    
    var name = ""
    var userUrl = ""
    
    var userInfo = JSON()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func updateInfo(user: JSON, indexPath: IndexPath) {
        userInfo = JSON()
        name = user["login"].string ?? ""
        nameLabel.text = name
        
        avatarImage.sd_setImage(with: user["avatar_url"].url, completed: nil)
        
        //get the public_repos num
        if let urlStr = user["url"].string {
            userUrl = urlStr
            AlamofireHeader.request(urlStr).responseJSON {[weak self] (response) in
                switch response.result {
                case .success(let json):
                    self?.updateRepo(data: json)
                    break
                case .failure(let error):
                    print("error:\(error)")
                    break
                }
            }
        }
    }
    
    public func pushDeatil(nav: UINavigationController?) {
        if userInfo.isEmpty && userUrl.isEmpty {
            UIAlertView(title: "Error", message: "Can't get user info!", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        // Push
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        viewController.userInfo = userInfo
        viewController.url = userUrl
        nav?.pushViewController(viewController, animated: true)
    }
    
    func updateRepo(data: Any) {
        let json = JSON.init(data)
        if let num = json["public_repos"].int {
            if let login = json["login"].string {
                if login == name {
                    print(login + ": repos:\(num)")
                    //if the user is different, don't do anything
                    repoLabel.text = "\(num)"
                    userInfo = json
                }
            }
        }
    }

}
