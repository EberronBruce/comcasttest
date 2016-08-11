//
//  ImageOperations.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import Foundation
import UIKit

enum ImageRecordState {
    case New, Downloaded, Failed
}

class ImageRecord {
    let name:String
    let url:NSURL
    var state = ImageRecordState.New
    var image = UIImage(named: "unknown")
    
    init(name: String, url: NSURL) {
        self.name = name
        self.url = url
    }
}

class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        return queue
    }()
}

class ImageDownloader: NSOperation {
    
    let imageRecord: ImageRecord
    
    init(imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL: self.imageRecord.url)
        
        if self.cancelled{
            return
        }
        
        if imageData?.length > 0 {
            self.imageRecord.image = UIImage(data: imageData!)
            self.imageRecord.state = .Downloaded
        } else {
            self.imageRecord.state = .Failed
            self.imageRecord.image = UIImage(named: "unknown")
        }
        
    }
    
}
