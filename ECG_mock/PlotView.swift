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
        print("\(dataArray)")
    }
}
