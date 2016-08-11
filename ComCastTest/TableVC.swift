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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        dataService.getInformationFromApi(API_URL)
        

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableVC.getDataFromDataService(_:)), name: API_NOTIFY, object: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataContainers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell") as? InformationCell {
            let data = dataContainers[indexPath.row]
            cell.setUpCell(title: data.title, description: data.description)
            
            if data.type != "" {
              
            }

            return cell
        } else {
            return InformationCell()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromDataService(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            if let dataContainer = notification.userInfo![NOTIFY_DICT_KEY] as? [DataContainer] {
                self.dataContainers = dataContainer
                self.tableView.reloadData()
                print("Notification Completed")
            }
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
