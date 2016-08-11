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
    var images = [ImageRecord]() //Used for NSOperations
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        dataService.getInformationFromApi(API_URL)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableVC.getDataFromDataService(_:)), name: API_NOTIFY, object: nil)
    }
    
    //Mark: - Table View Methods
    //------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataContainers.count
    }
    
    //Mark: - In the cell for row at index path, the cell is recycled and the images are pulled from data and checked if they have been downloaded.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell") as? InformationCell {
            let data = dataContainers[indexPath.row]
            cell.setUpCell(title: data.title, description: data.description)
            
            let imageDetails = images[indexPath.row]
            
            if data.type != nil {
                if imageDetails.image != nil {
                    cell.updateCellImage(imageDetails.image!)
                }
            } else {
                cell.updateCellImage(UIImage(named: "unknown")!)
            }
            
            switch (imageDetails.state) {
            case .Failed: break
            case .New, .Downloaded:
                self.startOperationsForImageRecord(imageDetails, indexPath: indexPath)
            }
            
            return cell
            
        } else {
            return InformationCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = dataContainers[indexPath.row]
        data.image = images[indexPath.row].image
        performSegueWithIdentifier("ImageSegue", sender: data)
        
        
    }
    //-----------------------------------------------------------------------------------
    
    //Mark: - This function calls the function to start downloading the images
    func startOperationsForImageRecord(imageDetails: ImageRecord, indexPath: NSIndexPath){
        switch (imageDetails.state) {
        case .New:
            startDownloadForRecord(imageDetails, indexPath: indexPath)
        case .Downloaded:
            NSLog("Downloaded")
        default:
            NSLog("do nothing")
        }
    }

    //Mark: - This function takes the infromation and calls the NSOperation classes to download the images based in index path. It takes one ImageRecord object and it takes a path. It does not return anything.
    func startDownloadForRecord(imageDetails: ImageRecord, indexPath: NSIndexPath){
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }

        let downloader = ImageDownloader(imageRecord: imageDetails)
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }

    //Mark: - This function is called from the notification and it takes the data and puts it in to the dataContainer and in the images arrary.
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
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ImageSegue" {
            if let detailVC = segue.destinationViewController as? DetailVC {
                if let data = sender as? DataContainer {
                    detailVC.data = data
                }
            }
        }
    }

}
