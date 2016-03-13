//
//  CurrentWindView.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 13/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class CurrentWindView: UIView {

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        WindFace(context: context, rect: rect).draw()
    }

}
