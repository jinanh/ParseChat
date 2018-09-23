//
//  ViewController.swift
//  Parse Chat
//
//  Created by Jinan Huang on 9/21/18.
//  Copyright © 2018 Jinan Huang. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var window = UIWindow()
    var messages: [PFObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chatMessageField: UITextField!
    
    @IBAction func sendButton(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageField.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        // Logout the current user
        
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let user = PFUser.current() ?? nil
                print("Successful logout")
                print(user as Any)
                
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            }
            
        })
    }
    
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50
        queryMessage()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        let chat_message = message["text"] as! String
        cell.chatMessage.text = chat_message
        
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.username.text = user.username
        } else {
            // No user found, set default username
            cell.username.text = "🤖"
        }
        return cell
    }
    
    func queryMessage(){
        
        // construct query
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                
                for message in posts{
                    print(message["text"])
                }
                
                self.messages = posts
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    @objc func onTimer(){
        queryMessage()
    }

}

