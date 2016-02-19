//
//  PostCell.swift
//  ahoogen-firebase
//
//  Created by Austen Hoogen on 2/17/16.
//  Copyright © 2016 Austen Hoogen. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, image: UIImage?) {
        self.post = post
        
        likeRef = DataService.ds.USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        self.descriptionTxt.text = post.postDesc
        self.likesLbl.text = "\(post.likes)"
        
        if post.imgUrl != nil {
            if image != nil {
                self.showcaseImg.image = image
            } else {
                request = Alamofire.request(.GET, post.imgUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                    if error == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imgUrl!)
                    } else {
                        self.showcaseImg.hidden = true
                    }
                })
            }
        } else {
            showcaseImg.hidden = true
        }
        
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart-empty")
            } else {
                self.likeImg.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
        })
    }
}
