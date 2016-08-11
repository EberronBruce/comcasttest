//
//  TableVC.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import UIKit

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataContainers = [DataContainer]()
    
    let dataService = DataService()
    
    var images = [ImageRecord]()
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        dataService.getInformationFromApi(API_URL)
        

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableVC.getDataFromDataService(_:)), name: API_NOTIFY, object: nil)
    }
    
    
    
    ///-------------------------------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataContainers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell") as? InformationCell {
            let data = dataContainers[indexPath.row]
            cell.setUpCell(title: data.title, description: data.description)
            
            let photoDetails = images[indexPath.row]
            
            if data.type != nil {
                if photoDetails.image != nil {
                    cell.updateCellImage(photoDetails.image!)
                }
            } else {
                cell.updateCellImage(UIImage(named: "unknown")!)
            }
            
            switch (photoDetails.state) {
            case .Failed: break
                //cell.textLabel?.text = "Failed to load"
            case .New, .Downloaded:
                //indicator.startAnimating()
                if (!tableView.dragging && !tableView.decelerating) {
                    self.startOperationsForPhotoRecord(photoDetails, indexPath: indexPath)
                }
            }
            
            return cell
            
//            if data.type != "" {
//                if data.image == nil {
//                    getImagesFromDataService(indexPath.row, urlString: data.link)
//                }else {
//                    cell.updateCellImage(data.image!)
//                }
//            } else {
//                cell.updateCellImage(UIImage(named: "unknown")!)
//            }
//
//            return cell
        } else {
            return InformationCell()
        }
    }
    
    func startOperationsForPhotoRecord(photoDetails: ImageRecord, indexPath: NSIndexPath){
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(photoDetails, indexPath: indexPath)
        case .Downloaded:
            NSLog("Downloaded")
        default:
            NSLog("do nothing")
        }
    }

    func startDownloadForRecord(photoDetails: ImageRecord, indexPath: NSIndexPath){
        //1
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        //2
        let downloader = ImageDownloader(imageRecord: photoDetails)
        //3
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromDataService(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            if let dataContainer = notification.userInfo![NOTIFY_DICT_KEY] as? [DataContainer] {
                self.dataContainers = dataContainer
                for data in self.dataContainers {
                    let imageDetail = ImageRecord(name: data.title, url: NSURL(string: data.link)!)
                    self.images.append(imageDetail)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func getImagesFromDataService(index: Int, urlString: String) {
        if dataContainers[index].image == nil {
            let mConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(mConcurrentQueue) {
                let img = self.dataService.downloadImage(urlString: urlString)
                self.dataContainers[index].image = img
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
