//
//  FeedVC.swift
//  ahoogen-firebase
//
//  Created by Austen Hoogen on 2/17/16.
//  Copyright © 2016 Austen Hoogen. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImg: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var posts = [Post]()
    static var imageCache = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 409
        
        DataService.ds.POSTS.observeEventType(.Value, withBlock: { snapshot in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImg.image = image
        imageSelected = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            cell.request?.cancel()
            var img: UIImage?
            
            if let url = post.imgUrl {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, image: img)
            return cell
        }
        
        return PostCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.imgUrl == nil {
            return 200
        }
        
        return tableView.estimatedRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnPressed(sender: AnyObject) {
        if let desc = postField.text where desc != "" {
            if let img = imageSelectorImg.image where imageSelected == true {
                // Prepare data for upload request
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                // Start upload
                Alamofire.upload(
                    .POST,
                    url,
                    multipartFormData: { multipartFormData  in
                        // Attach data and parameters
                        multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpeg")
                        multipartFormData.appendBodyPart(data: keyData, name: "key")
                        multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    },
                    // Pass results into an encoder/decoder
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            // Get results in decoded JSON
                            upload.responseJSON(completionHandler: { response in
                                // Get the result of the response
                                let result = response.result
                                
                                // Get the value of the result (this is the decoded JSON)
                                if let res = result.value as? Dictionary<String, AnyObject> {
                                    
                                    // Work with the JSON
                                    if let links = res["links"] as? Dictionary<String, AnyObject> {
                                        print(links["image_link"])
                                        let imgUrl = links["image_link"] as? String
                                        self.postToFirebase(imgUrl)
                                    }
                                }
                            })
                        case .Failure(let error):
                            print(error)
                        }
                    }
                )
            } else {
                self.postToFirebase(nil)
            }
        }
    }
    
    func postToFirebase(imgUrl: String?) {
        var post: Dictionary<String, AnyObject> = [
            "description": postField.text!,
            "likes": 0
        ]
        
        if imgUrl != nil {
            post["imgUrl"] = imgUrl!
        }
        
        let firebasePost = DataService.ds.POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postField.text = ""
        imageSelectorImg.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
    }
}
