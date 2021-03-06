//
//  HomeFeedViewController.swift
//  InstagramDemo
//
//  Created by Timothy Mak on 12/3/17.
//  Copyright © 2017 Timothy Mak. All rights reserved.
//

import UIKit
import Parse

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var feed: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        updateHomeFeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = feed[indexPath.row]
        
        if let photo = post.media {
            photo.getDataInBackground(block: { (data, error) in
                if let data = data {
                    cell.postImageView.image = UIImage(data: data)
                }
                else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            })
        }
        cell.postDescriptionLabel.text = post.caption
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        updateHomeFeed()
        refreshControl.endRefreshing()
    }
    
    func updateHomeFeed() {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) -> Void in
            if let posts = posts {
                self.feed = posts as! [Post]
                self.tableView.reloadData()
            }
            else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! PostCell
            if let indexPath = tableView.indexPath(for: cell) {
                let post = feed[indexPath.row]
                let detailVC = segue.destination as! PostDetailViewController
                detailVC.post = post
            }
        }
    }
    

}
