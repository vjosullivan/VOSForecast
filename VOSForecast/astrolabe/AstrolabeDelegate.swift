//
//  AstrolabeDelegate.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 20/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

protocol AstrolabeDelegate {

    var hours:   Int { get set } // = 10
    var minutes: Int { get set } // = 10
    var seconds: Int { get set } // = 0

    // MARK: Time

    ///  The time that is currently displayed on the clock.  Called everytime the time on the clock changes.
    ///
    ///  - parameters:
    ///    - clock:   The clock object which is currently displaying the time.
    ///    - hours:   The hours currently displayed on the clock by the hour hand.
    ///    - minutes: The minutes currently displayed on the clock by the minute hand.
    ///    - seconds: The seconds currently displayed on the clock by the second hand. */
    ///
    func currentTime(hours hours: Int, minutes: Int, seconds: Int)
}
