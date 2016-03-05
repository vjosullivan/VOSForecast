//
//  MainViewController.swift
//  VOSClock
//
//  Created by Vincent O'Sullivan on 20/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var mainClock: VOSClockView!

    var timeText: String = ""

    internal var hours:   Int = 0
    internal var minutes: Int = 0
    internal var seconds: Int = 0

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure main clock.
        mainClock.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Extensions
// MARK: - VOSClockDelegate extension

extension MainViewController: VOSClockDelegate {

    func currentTime(hours hours: Int, minutes: Int, seconds: Int) {
        timeText = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
