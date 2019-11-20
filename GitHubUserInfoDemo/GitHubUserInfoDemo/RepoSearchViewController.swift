//
//  RepoSearchViewController.swift
//  GitHubUserInfoDemo
//
//  Created by Yasin on 11/20/19.
//  Copyright © 2019 Yasin. All rights reserved.
//

import UIKit
import SwiftyJSON

class RepoSearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    public var dataArray = [JSON]()
    var resultArray = [JSON]()
    var nameDict = [String: Int]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped(sender:)))
        searchBar.becomeFirstResponder()
        searchBar.autocapitalizationType = .none
        // Do any additional setup after loading the view.
        
        paramData()
    }
    @objc func backTapped(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: false)
    }
    
    func paramData() {
        for (index, repo) in dataArray.enumerated() {
            if let name = repo["name"].string {
                nameDict[name] = index
            }
        }
    }
    
}
extension RepoSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUserName(name: searchText)
    }
    
    func searchUserName(name: String) {
        print("search:" + name)
        if (name.isEmpty) {
            resultArray = [JSON]()
            tableView.reloadData()
            return
        }
        resultArray = [JSON]()
        
        for meb in nameDict.keys {
            let ignore_Text_transformRange = meb.range(of:name, options: .caseInsensitive, range:nil , locale:nil)//ignore case
            if ignore_Text_transformRange != nil{
                resultArray.append(dataArray[nameDict[meb]!])
            }
        }
        
        tableView.reloadData()
    }
}
extension RepoSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify:String = "UserRepoTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath as IndexPath) as! UserRepoTableViewCell
        let repo = resultArray[indexPath.row]
        cell.updateInfo(json: repo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = resultArray[indexPath.row]
        if let url = repo["html_url"].string {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RepoWebViewController") as! RepoWebViewController
            viewController.url = url
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}
