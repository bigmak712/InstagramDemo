//
//  PostDetailViewController.swift
//  InstagramDemo
//
//  Created by Timothy Mak on 12/4/17.
//  Copyright © 2017 Timothy Mak. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let post = post {
            if let photo = post.media {
                photo.getDataInBackground(block: { (data, error) in
                    if let data = data {
                        self.postImageView.image = UIImage(data: data)
                    }
                    else {
                        print("Error: \(String(describing: error?.localizedDescription))")
                    }
                })
            }
            captionLabel.text = post.caption
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
