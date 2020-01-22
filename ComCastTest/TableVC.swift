//
//  TableVC.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import UIKit

class TableVC: UIViewController  {
    

    @IBOutlet weak var tableView: UITableView!
    
    var dataContainers = [DataContainer]()
    let dataService = DataService()
    var images = [ImageRecord]() //Used for NSOperations
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        dataService.getInformationFromApi(urlString: API_URL)
        NotificationCenter.default.addObserver(self, selector: #selector(TableVC.getDataFromDataService(notification:)), name: NSNotification.Name(API_NOTIFY), object: nil)
    }
    
    //Mark: - Table View Methods
    //------------------------------------------------------------------------------------
    /*
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
        
        
    }*/
    //-----------------------------------------------------------------------------------
    
    //Mark: - This function calls the function to start downloading the images
    func startOperationsForImageRecord(imageDetails: ImageRecord, indexPath: NSIndexPath){
        switch (imageDetails.state) {
        case .New:
            startDownloadForRecord(imageDetails: imageDetails, indexPath: indexPath)
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
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [(indexPath as IndexPath)], with: .fade)
            }
        }
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }

    //Mark: - This function is called from the notification and it takes the data and puts it in to the dataContainer and in the images arrary.
    @objc func getDataFromDataService(notification: NSNotification) {
        DispatchQueue.main.async {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "ImageSegue" {
              if let detailVC = segue.destination as? DetailVC {
                  if let data = sender as? DataContainer {
                      detailVC.data = data
                  }
              }
          }
      }

}


extension TableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataContainers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as? InformationCell {
            let data = dataContainers[indexPath.row]
            cell.setUpCell(title: data.title, description: data.description)
            
            let imageDetails = images[indexPath.row]
            
            if data.type != nil {
                if imageDetails.image != nil {
                    cell.updateCellImage(image: imageDetails.image!)
                }
            } else {
                cell.updateCellImage(image: UIImage(named: "unknown")!)
            }
            
            switch (imageDetails.state) {
            case .Failed: break
            case .New, .Downloaded:
                self.startOperationsForImageRecord(imageDetails: imageDetails, indexPath: indexPath as NSIndexPath)
            }
            
            return cell
            
        } else {
            return InformationCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataContainers[indexPath.row]
        data.image = images[indexPath.row].image
        performSegue(withIdentifier: "ImageSegue", sender: data)
    }
    
}
