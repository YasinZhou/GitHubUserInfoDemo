//
//  ViewController.swift
//  GitHubUserInfoDemo
//
//  Created by Yasin on 11/19/19.
//  Copyright © 2019 Yasin. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataArray = [JSON]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.autocapitalizationType = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(login(sender:)))
        // Do any additional setup after loading the view.
        
    }
    
    @objc func login(sender: UIBarButtonItem) {
        UIApplication.shared.open(URL(string: "https://github.com/login/oauth/authorize?client_id=dd3378e2a461c81d6755")!)

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "GithubLoginViewController") as! GithubLoginViewController
//        viewController.url = "https://github.com/login/oauth/authorize?client_id=dd3378e2a461c81d6755"
//        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func searchUserName(name: String) {
        print("search:" + name)
        if (name.isEmpty) {
            updateData(data: "")
            return
        }
        
        let urlStr = "https://api.github.com/search/users"
        AlamofireHeader.request(urlStr, parameters: ["q":name]).responseJSON {[weak self] (response) in
            switch response.result {
            case .success(let json):
                
                self?.updateData(data: json)
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
    }
    
    func updateData(data : Any) {
        let json = JSON.init(data)
        if let msg = json["message"].string {
            UIAlertView(title: "Error", message: msg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        if let items = json["items"].array {
            print("ss:" + "\(items.count)")
            dataArray = items
        }
        tableView.reloadData()
    }

}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUserName(name: searchText)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify:String = "UserSearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath as IndexPath) as! UserSearchTableViewCell
        let user = dataArray[indexPath.row]
        cell.updateInfo(user: user, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserSearchTableViewCell
        
        cell.pushDeatil(nav: navigationController)
        
        
    }
}
