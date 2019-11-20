//
//  UserDetailViewController.swift
//  GitHubUserInfoDemo
//
//  Created by Yasin on 11/20/19.
//  Copyright © 2019 Yasin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class UserDetailViewController: UIViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var folloswerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var biogLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    public var userInfo = JSON()
    public var url = ""
    var dataArray = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("detail")
        print(userInfo)
        print("URL: " + url)
        
        if userInfo["login"].string != nil {
            updateInfo()
        } else {
            if url.isEmpty {return}
            AlamofireHeader.request(url).responseJSON {[weak self] (response) in
                switch response.result {
                case .success(let json):
                    let data = JSON.init(json)
                    self?.userInfo = data;
                    self?.updateInfo()
                    break
                case .failure(let error):
                    print("error:\(error)")
                    break
                }
            }
            
        }
    }
    
    func updateInfo() {
        if let msg = userInfo["message"].string {
            UIAlertView(title: "Error", message: msg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        nameLabel.text = userInfo["login"].string
        avatarImage.sd_setImage(with: userInfo["avatar_url"].url, completed: nil)
        folloswerLabel.text = "Folloswer: " + "\((userInfo["followers"].int ?? 0))"
        followingLabel.text = "Folloswing: " + "\((userInfo["following"].int ?? 0))"
        emailLabel.text = "Email: " + (userInfo["email"].string ?? "")
        locationLabel.text = "Location: " + (userInfo["location"].string ?? "")
        joinDateLabel.text = "Join date: " + (userInfo["created_at"].string ?? "")
        biogLabel.text = "Biog: " + (userInfo["bio"].string ?? "")
        getRepo()
    }
    
    func getRepo() {
        if let urlStr = userInfo["repos_url"].string {
            AlamofireHeader.request(urlStr).responseJSON {[weak self] (response) in
                switch response.result {
                case .success(let json):
                    self?.updateTableview(data: json)
                    break
                case .failure(let error):
                    print("error:\(error)")
                    break
                }
            }
        }
    }
    
    func updateTableview(data : Any) {
        let json = JSON.init(data)
        if let msg = json["message"].string {
            UIAlertView(title: "Error", message: msg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        if let items = json.array {
            print("ss:" + "\(items.count)")
            dataArray = items
        }
        tableview.reloadData()
    }
}
extension UserDetailViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if dataArray.count > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RepoSearchViewController") as! RepoSearchViewController
            viewController.dataArray = dataArray
            navigationController?.pushViewController(viewController, animated: false)
        }
        return false
    }
    
}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify:String = "UserRepoTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath as IndexPath) as! UserRepoTableViewCell
        let repo = dataArray[indexPath.row]
        cell.updateInfo(json: repo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = dataArray[indexPath.row]
        if let url = repo["html_url"].string {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RepoWebViewController") as! RepoWebViewController
            viewController.url = url
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}
