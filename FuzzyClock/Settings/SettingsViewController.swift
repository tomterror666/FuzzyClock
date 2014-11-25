//
//  SettingsViewController.swift
//  FuzzyClock
//
//  Created by Andre Hess on 25.11.14.
//  Copyright (c) 2014 Andre Hess. All rights reserved.
//

import UIKit

let cellIdentifier:String = "settingsCellIdentifier"

protocol SettingsHandlingProtocol {
	func settingsViewControllerDidFinishedSuccessfully(SettingsViewController)
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ColorSelectionProtocol {
	
	@IBOutlet weak var myNavigationBar:UINavigationBar!
	@IBOutlet weak var myNavigationItem:UINavigationItem!
	@IBOutlet weak var myTableView:UITableView!
	
	@IBAction func doneButtonTouched(AnyObject) {
		self.delegate?.settingsViewControllerDidFinishedSuccessfully(self)
	}
	
	var delegate:SettingsHandlingProtocol?
	var choosedBackgroundColor:UIColor?
	var choosenBackgroundImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

		self.configureNavigationBar()
		self.configureTableView()		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
	/* 
		// MARK: configuration
	*/
	
	func configureNavigationBar() {
		var navigationBarFrame = self.myNavigationBar.frame
		navigationBarFrame.size.height = 64.0
		self.myNavigationBar.frame = navigationBarFrame
		
		self.myNavigationItem.title = NSLocalizedString("settings", comment: "")
	}
	
	func configureTableView() {
		self.myTableView .registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
	}

    /*
		// MARK: - UITableViewDataSource and UITableViewDelegate
    */
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let __cell:AnyObject = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
		var cell:UITableViewCell = __cell as UITableViewCell
		
		switch indexPath.row {
			case 0:
				cell.textLabel.text = NSLocalizedString("selectBackgroundColor", comment: "")
				cell.textLabel.textColor = self.choosedBackgroundColor
				cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
			case 1:
				cell.textLabel.text = NSLocalizedString("selectBackgroundImage", comment: "")
				cell.accessoryType = UITableViewCellAccessoryType.None
			default:
				break
		}
		
		return cell
	}
		
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		if ((indexPath.row == 0) && (indexPath.section == 0)) {
			let controller:SelectColorViewController = SelectColorViewController(nibName:"SelectColorViewController", bundle:nil)
			controller.delegate = self
			controller.selectedColor = self.choosedBackgroundColor!
			self.presentViewController(controller, animated: true, completion: nil)
		}
	}

	/*
		// MARK: - ColorSelectionProtocol
	*/
	
	func selectColorViewControllerFinishedSuccessfully(controller:SelectColorViewController) {
		let cell:UITableViewCell = self.myTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!
		cell.textLabel.textColor = controller.selectedColor
		self.choosedBackgroundColor = controller.selectedColor
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
