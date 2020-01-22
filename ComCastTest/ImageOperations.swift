//
//  ImageOperations.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import Foundation
import UIKit

//This is the selection fo states when downloaded
enum ImageRecordState {
    case New, Downloaded, Failed
}

//This class is a container class that holds information used in the populating the table view as well as other information
class ImageRecord {
    let name:String
    let url:NSURL
    var state = ImageRecordState.New
    var image = UIImage(named: "empty")
    
    init(name: String, url: NSURL) {
        self.name = name
        self.url = url
    }
}

//This sets up the NSOperations and holds the queues for downloads
class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:Operation]()
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
}

//This class is uses NSOperation to download the image given a url. It constantly checks to see if has been canceled.
class ImageDownloader: Operation {
    
    let imageRecord: ImageRecord
    
    init(imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        let imageData = NSData(contentsOf: self.imageRecord.url as URL)
        
        if self.isCancelled{
            return
        }
        
        if imageData!.length > 0 {
            self.imageRecord.image = UIImage(data: imageData! as Data)
            self.imageRecord.state = .Downloaded
        } else {
            self.imageRecord.state = .Failed
            self.imageRecord.image = UIImage(named: "unknown")
        }
        
    }
    
}
