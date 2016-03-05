//
//  CALayerExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 04/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

///  This extension makes it possible to set the border color on UIViews in the interface builder.
extension CALayer {

    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.CGColor
        }

        get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
}