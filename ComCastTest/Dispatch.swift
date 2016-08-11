//
//  Dispatch.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import Foundation


public struct Dispatch {
    public typealias Block = () -> ()
    
    public static func main(block: Block) {
        async(dispatch_get_main_queue(), block: block)
    }
    
    public static func async(queue: dispatch_queue_t = dispatch_queue_create("com.abaraba.dispatch.async", DISPATCH_QUEUE_SERIAL), block: Block) {
        dispatch_async(queue, block)
    }
}