//
//  ViewController.swift
//  ECG_mock
//
//  Created by Helmut Strey on 1/25/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    
    //BLE
    var centralManager : CBCentralManager!
    var ECGsensorPeripheral : CBPeripheral!

    let BLEdevices = [
        ("ECG Sensor 1","BA12-A456-799A-1111"),
        ("ECG Sensor 2","BA12-A456-799A-1112"),
        ("EMG Sensor 1","BA12-A456-799A-1113"),
        ("EMG Sensor 2","BA12-A456-799A-1114") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.addSubview(self.refreshControl)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // pull to refresh controller
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    // Table Data Source
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
    
    // pull to refresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    /******* CBCentralManagerDelegate *******/
     
     // Check status of BLE hardware
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if central.state == CBCentralManagerState.PoweredOn {
            // Scan for peripherals if BLE is turned on
            central.scanForPeripheralsWithServices(nil, options: nil)
        }
        else {
            // Can have different conditions for all states if needed - show generic alert for now
            print("Error: Bluetooth switched off or not initialized")
        }
    }
    
    
    // Check out the discovered peripherals to find Sensor Tag
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Found device: ",advertisementData)
    }
    
    // Discover services of the peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Discovering peripheral services")
        peripheral.discoverServices(nil)
    }
    
    
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected")
        central.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    /******* CBCentralPeripheralDelegate *******/
     
     // Check if the service discovered is valid i.e. one of the following:
     // IR Temperature Service
     // Accelerometer Service
     // Humidity Service
     // Magnetometer Service
     // Barometer Service
     // Gyroscope Service
     // (Others are not implemented)
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("Looking at peripheral services")
    }
    
    
    // Enable notification and sensor for each characteristic of valid service
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        print("Enabling sensors")
        
    }
    
    
    
    // Get data values when they are updated
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        print("Connected")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

