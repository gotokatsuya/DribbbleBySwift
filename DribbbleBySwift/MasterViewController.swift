//
//  MasterViewController.swift
//  DribbbleBySwift
//
//  Created by KatsuyaGoto on 2014/06/11.
//  Copyright (c) 2014年 KatsuyaGoto. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController{

    var items: Item[] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.search();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var detailViewController: DetailViewController = segue.destinationViewController as DetailViewController
            var index = self.tableView.indexPathForSelectedRow().row
            var selectedItem = self.items[index].title
            (segue.destinationViewController as DetailViewController).detailItem = selectedItem
        }
    }
    
    
    // #pragma mark - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let item = items[indexPath.row] as Item
        cell.textLabel.text = item.title
        
        var q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        var q_main: dispatch_queue_t  = dispatch_get_main_queue();
        dispatch_async(q_global, {
            var imageURL: NSURL = NSURL.URLWithString(item.imageUrl)
            var imageData: NSData = NSData(contentsOfURL: imageURL)
            
            var image: UIImage = UIImage(data: imageData)
            dispatch_async(q_main, {
                    cell.image = image;
                    cell.layoutSubviews()
                })
            })
        
        return cell
    }
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func search(){
        let manager = AFHTTPRequestOperationManager()
        manager.GET("http://api.dribbble.com//shots/debuts?page=1", parameters: nil,
        success: {
        (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            var jsonResult = responseObject as Dictionary<String, AnyObject>
            
            var shots : NSArray = jsonResult["shots"] as NSArray
           
            for result: AnyObject in shots {
                var title: String? = result["title"] as? String
                var image_url: String? = result["image_url"] as? String
            
                var newItem = Item(title: title, imageUrl: image_url)
                self.items.append(newItem)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
            print(error)
        })
    }
    
}

