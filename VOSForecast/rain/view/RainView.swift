//
//  RainView.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 15/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class RainView: UIView {

    // MARK: - Propeties

    var shouldUpdateSubviews: Bool = true

    // MARK: - Functions

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()!
        RainFace(context: context, rect: rect).draw()
    }

    override func layoutSubviews() {
        if shouldUpdateSubviews {
            // Any permanent visual features can go here.
            shouldUpdateSubviews = false
        }
    }
}
