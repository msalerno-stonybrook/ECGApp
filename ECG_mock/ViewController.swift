//
//  ViewController.swift
//  ECG_mock
//
//  Created by Helmut Strey on 1/25/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    
    let BLEdevices = [
        ("ECG Sensor 1","BA12-A456-799A-1111"),
        ("ECG Sensor 2","BA12-A456-799A-1112"),
        ("EMG Sensor 1","BA12-A456-799A-1113"),
        ("EMG Sensor 2","BA12-A456-799A-1114") ]
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLEdevices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let (BLEname, uuid) = BLEdevices[indexPath.row]
        cell.textLabel?.text = BLEname
        cell.detailTextLabel?.text = uuid
        
        let myImage = UIImage(named: "Cell_Icons")
        cell.imageView?.image = myImage
        
        return cell
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

