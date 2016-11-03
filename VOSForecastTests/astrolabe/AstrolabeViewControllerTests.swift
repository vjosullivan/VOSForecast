//
//  AstrolabeViewControllerTests.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 23/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import XCTest

class AstrolabeViewControllerTests: XCTestCase {

    var viewController: AstrolabeViewController!

    override func setUp() {
        super.setUp()

        let name = getStoryboardName()
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: Bundle(for: type(of: self)))
        viewController = storyboard.instantiateViewController(withIdentifier: "AstrolabeViewController") as! AstrolabeViewController
        viewController.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let frontView = UIView()
        let rearView  = UIView()
        viewController.astrolabeFrontPanel = frontView
        viewController.astrolabeRearPanel  = rearView
        let button = UIButton()
        viewController.actionFlipPanel(button)
        XCTAssertTrue(viewController.astrolabeFrontPanel.isHidden, "Panel should be hidden")
    }

    func getStoryboardName() -> String {
        let info = Bundle.main.infoDictionary!
        let name = info["TPMainStoryboardName"] as? String ?? "Main"
        print("Name:", name)
        return name
    }
}
