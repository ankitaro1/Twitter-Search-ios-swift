//
//  ViewController.swift
//  Comviva Twitter
//
//  Created by com.mfs.db on 15/01/20.
//  Copyright © 2020 com.mfs.db. All rights reserved.
//


import UIKit
import Alamofire
import Nuke


class ViewController: UIViewController ,
UISearchBarDelegate , UITableViewDataSource , UITableViewDelegate {


@IBOutlet weak var tableView: UITableView!

@IBOutlet weak var searchBar: UISearchBar!

var hashtag : String?
var dataobject : Welcome? = nil
var rowCount = 0
var token : Token? = nil

    

override func viewDidLoad() {
    super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register( UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCellTwitter")
}



func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    if searchBar.text != "" {
        hashtag = searchBar.text!
        print(hashtag!)
        tokenGenerator()
        
    }
    else{
        rowCount = 0
        tableView.reloadData()
        self.errorAlert(error: "search bar is empty")
    }
}

func tokenGenerator(){
    let constants = Constants()
    let tokenCredentials = "\(constants.consumerKey):\(constants.secretKey)"

    let tokenCredentialsBase64 = (tokenCredentials.data(using: String.Encoding.utf8)?.base64EncodedString())!
    let Header = HTTPHeaders.init(dictionaryLiteral: ("Authorization", "Basic \(tokenCredentialsBase64)"),("Content-Type" , "application/x-www-form-urlencoded;charset=UTF-8"))
    firstApi( header : Header)

}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.rowCount
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCellTwitter", for: indexPath) as! CustomCell
        tableView.rowHeight = 150
        cell.nameLabel.text = dataobject?.statuses[indexPath.row].user.name
        cell.textViewField.text = dataobject?.statuses[indexPath.row].text
        let url = URL.init(string: (dataobject?.statuses[indexPath.row].user.profile_image_url_https)!)
        Nuke.loadImage(with: url!, into: cell.twitterDpView)
        return cell
}

    func  errorAlert( error : String){
        let alert = UIAlertController(title: "ERROR", message: error , preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
    }
    
    
    func firstApi(header : HTTPHeaders ) {
        Alamofire.request("https://api.twitter.com/oauth2/token?grant_type=client_credentials", method: .post, parameters: nil , encoding: JSONEncoding.default, headers: header).responseJSON {(postresponse) in
                guard postresponse.result.isSuccess else {
                    self.rowCount = 0
                    self.tableView.reloadData()
                    self.errorAlert(error: postresponse.result.error.debugDescription)
                return
                }

                do{
                let tok = try JSONDecoder().decode(Token.self , from : postresponse.data!)
                self.token = tok
                    self.secondApi()
                }
                catch let error {
                    self.rowCount = 0
                    self.tableView.reloadData()
                    self.errorAlert(error: error.localizedDescription)
                }
        }
        
    }
    
    
    func secondApi(){
          let getheader = HTTPHeaders.init(dictionaryLiteral: ("authorization" , "bearer AAAAAAAAAAAAAAAAAAAAAA8qDQAAAAAA9T7thAHuSMhSj4XP0SP3MuCXirs%3DQU9PlY3P01FuUBs3CAgfPkB4SQ4xfCv52ndAJdaoSXSb6qn75i"))
        let geturl = "https://api.twitter.com/1.1/search/tweets.json?q=\(self.hashtag!)&count=100"
            let encgeturl = geturl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encgeturl! , method: .get, parameters: nil , encoding: JSONEncoding.default, headers: getheader).responseJSON{ (response) in
                guard response.result.isSuccess else {
                    self.rowCount = 0
                    self.tableView.reloadData()
                    self.errorAlert(error: response.result.error.debugDescription)
                    return
                }
            
                do {
                    let decoder = JSONDecoder()
                    let wc = try decoder.decode( Welcome.self, from: response.data!)
                    self.dataobject = wc
                    self.rowCount = (self.dataobject?.statuses.count)!
                    self.tableView.reloadData()
                }catch let error {
                    self.rowCount = 0
                    self.tableView.reloadData()
                    self.errorAlert(error: error.localizedDescription)
                }

        }
    }

    }


