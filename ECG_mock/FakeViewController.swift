//
//  FakeViewController.swift
//  ECG_mock
//
//  Created by Michael Salerno on 11/14/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit

class FakeViewController: UIViewController {

    @IBOutlet weak var displayTimeLabel: UILabel!
    
    var startTime = TimeInterval()
    var timer:Timer = Timer()
    var endTime: Date!
    var alarmTime: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func start(_ sender: Any) {
        alarmTime = Date()
        if (!timer.isValid) {
            let aSelector : Selector = #selector(FakeViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
        
    }
    
    @IBAction func stop(_ sender: Any) {
        endTime = Date()
        timer.invalidate()
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
