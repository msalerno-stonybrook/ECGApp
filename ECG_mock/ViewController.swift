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

    var BLEdevices = [CBPeripheral]()
    var refreshTimer: Timer?
    // This needs to be adjusted to use the fake data generator
    var fakeData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.addSubview(self.refreshControl)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // pull to refresh controller
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    // Table Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fakeData == true {
            return BLEdevices.count + 1
        }
        else {
            return BLEdevices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if fakeData == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
            
            if let BLEname = BLEdevices[indexPath.row].name {
                cell.textLabel?.text = BLEname
            }
            
            let myImage = UIImage(named: "Cell_Icons")
            cell.imageView?.image = myImage
            
            return cell
        }
            
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellfake", for: indexPath) as UITableViewCell
            cell.textLabel?.text = "Fake Data Generator"
            let myImage = UIImage(named: "Cell_Icons")
            cell.imageView?.image = myImage
            
            return cell
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if fakeData == true {
            let FakeECGViewer=segue.destination as! FakeViewController
        }
        else {
            
            let ECGViewer=segue.destination as! ECGViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // pass the peripheral that was selected to new view controller
                ECGViewer.ECGsensor=BLEdevices[indexPath.row]
            }
            // also pass central manager in case it changes status
            ECGViewer.CBManager=centralManager
            ECGViewer.CBManager.delegate = ECGViewController.self as? CBCentralManagerDelegate
        }
    }
    
    // pull to refresh
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        print("Scanning...")
        BLEdevices.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        refreshTimer=Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.afterScanning),userInfo: nil, repeats: false)
    }
    
    func afterScanning() {
        print("finished scanning")
        centralManager.stopScan()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    /******* CBCentralManagerDelegate *******/
     
     // Check status of BLE hardware
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let state = central.state
        if #available(iOS 10.0, *) {
            if state == CBManagerState.poweredOn {
                print("Central Manager is Powered on...")
            }
            else {
                // Can have different conditions for all states if needed - show generic alert for now
                print("Error: Bluetooth switched off or not initialized")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Check out the discovered peripherals to find Sensor Tag
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Found device: ",advertisementData)
        if let nameOfDeviceFound = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString {
            if (nameOfDeviceFound.hasPrefix("ECG-Sensor")) {
                // add peripheral to BLE devices array if not already in there
                if !BLEdevices.contains(peripheral) {
                    BLEdevices.append(peripheral)
                    self.tableView.reloadData()
                }
            }

        }
    }
    
//    // Discover services of the peripheral
//    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
//        print("Discovering peripheral services")
//        peripheral.discoverServices(nil)
//    }
//
    
    // If disconnected, start searching again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected")
        central.scanForPeripherals(withServices: nil, options: nil)
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
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Looking at peripheral services")
    }
    
    
    // Enable notification and sensor for each characteristic of valid service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("Enabling sensors")
        
    }
    
    // Get data values when they are updated
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        print("Connected")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToBLEtable(_ unwindSegue: UIStoryboardSegue) {
        print("pressed Disconnect")
        centralManager.delegate = self
        // need to set the delegate back to previous view controller
        if let SourceController = unwindSegue.source as? ECGViewController {
            print("cancel connection to BLEsensor")
            centralManager.cancelPeripheralConnection(SourceController.ECGsensor)
        }
    }
  
    
    
}

