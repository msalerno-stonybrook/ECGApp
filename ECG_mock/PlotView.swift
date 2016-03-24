//
//  PlotView.swift
//  ECG_mock
//
//  Created by Helmut Strey on 3/23/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit
protocol ECGDataSource {
    func dataYforWidth(width : Int) -> [Int]
}

class PlotView: UIView {

    var delegate : ECGDataSource?
    
    
    override func drawRect(rect: CGRect) {
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
                path.moveToPoint(CGPoint(x:CGFloat(i-start), y:viewHeigth/2.0-startPoint))
                let nextPoint = CGFloat(dataArray![i])/20.0
                path.addLineToPoint(CGPoint(x:CGFloat(i-start+1), y:viewHeigth/2.0-nextPoint))
            }
            path.closePath()
            UIColor.redColor().setStroke()
            path.stroke()
        }
        
    }
}
