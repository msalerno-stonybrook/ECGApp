//
//  FakePlotView.swift
//  ECG_mock
//
//  Created by Michael Salerno on 11/21/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit
protocol FakeDataSource {
    func dataYforWidth(_ width : Int) -> [Int]
    func heartrate() -> Int
    //func PacketGeneration(v: Int) -> [UInt]
}

class FakePlotView: UIView {
    
    var delegate : FakeDataSource?
    
    
    override func draw(_ rect: CGRect) {
        let dataArray = delegate?.dataYforWidth(20)
        if (dataArray != nil) && dataArray!.count>1 {
            let dataLength=dataArray!.count
            let viewWidth=self.bounds.size.width
            let viewHeigth=self.bounds.size.height
            var start = dataLength-Int(viewWidth)
            if start<0 {
                start=0
            }
            print("datalength \(dataLength) start \(start) viewWidth \(viewWidth)")
            let path = UIBezierPath()
            for i in start+1...dataLength-1 {
                print("i \(i)")
                let startPoint = CGFloat(dataArray![i-1])/20.0
                path.move(to: CGPoint(x:CGFloat(i-start), y:viewHeigth/1.0-startPoint))
                let nextPoint = CGFloat(dataArray![i])/20.0
                path.addLine(to: CGPoint(x:CGFloat(i-start+1), y:viewHeigth/1.0-nextPoint))
            }
            path.close()
            UIColor.red.setStroke()
            path.stroke()
        }
        
    }
}
