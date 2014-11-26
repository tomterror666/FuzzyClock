//
//  ViewController.swift
//  FuzzyClock
//
//  Created by Andre Hess on 24.10.14.
//  Copyright (c) 2014 Andre Hess. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SettingsHandlingProtocol {
	
	@IBOutlet weak var timeLabel: FuzzyLabel!
	@IBOutlet weak var realTimeLabel: FuzzyLabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.configureSubviews()
		self.adjustTimerForTimeChecking()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func adjustTimerForTimeChecking() {
		
		var timeGetterTimer: NSTimer
		timeGetterTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("configureSubviews"), userInfo: nil, repeats: true)
	}
	
	/* 
		// MARK: - subview configuration
	*/
	
	func configureSubviews() {
		let now = NSDate()
		self.timeLabel.text = self.convertTimeToFuzzy(now)
		self.realTimeLabel.text = self.getCurrentTime()
	}

	/*
		// MARK: - button handling
 	*/
	
	@IBAction func preferencesButtonTouched(AnyObject) {
		let controller:SettingsViewController = SettingsViewController(nibName:"SettingsViewController", bundle:nil)
		controller.choosedBackgroundColor = self.view.backgroundColor
		controller.delegate = self
		self.presentViewController(controller, animated:true, completion:nil)
	}
	
	/*
		// MARK: - SettingsHandlingProtocol
	*/

	func settingsViewControllerDidFinishedSuccessfully(controller:SettingsViewController) {
		if (controller.choosenBackgroundImage != nil) {
			self.view.backgroundColor = UIColor(patternImage: controller.choosenBackgroundImage!)
		} else {
			self.view.backgroundColor = controller.choosedBackgroundColor
		}
		self.dismissViewControllerAnimated(true, completion:nil)
		dispatch_after(dispatch_time_t(1.0), dispatch_get_main_queue()) { () -> Void in
			self.timeLabel.textColorComputed = false
			self.realTimeLabel.textColorComputed = false
			self.timeLabel.setNeedsDisplay()
			self.realTimeLabel.setNeedsDisplay()
		}
	}
}

