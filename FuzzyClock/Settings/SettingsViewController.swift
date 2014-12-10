//
//  SettingsViewController.swift
//  FuzzyClock
//
//  Created by Andre Hess on 25.11.14.
//  Copyright (c) 2014 Andre Hess. All rights reserved.
//

import UIKit
import MobileCoreServices

let cellIdentifier:String = "settingsCellIdentifier"

protocol SettingsHandlingProtocol {
	func settingsViewControllerDidFinishedSuccessfully(SettingsViewController)
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ColorSelectionProtocol, WEPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var myNavigationBar:UINavigationBar!
	@IBOutlet weak var myNavigationItem:UINavigationItem!
	@IBOutlet weak var myTableView:UITableView!
	
	var delegate:SettingsHandlingProtocol?
	var choosedBackgroundColor:UIColor?
	var choosenBackgroundImage:UIImage?
	
	var popoverController:WEPopoverController!
	var mediaSources:[UIImagePickerControllerSourceType] = [UIImagePickerControllerSourceType]()

    override func viewDidLoad() {
        super.viewDidLoad()

		self.configureNavigationBar()
		self.configureTableView()
		self.configureMediaSources()
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
		self.myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
	}

	func configureCell(cell: UITableViewCell, forSourceType sourceType:UIImagePickerControllerSourceType) {
		switch sourceType {
		case UIImagePickerControllerSourceType.PhotoLibrary:
			cell.textLabel.text = NSLocalizedString("fromAlbum", comment: "")
			cell.indentationLevel = 2
			cell.accessoryType = UITableViewCellAccessoryType.None
		case UIImagePickerControllerSourceType.Camera:
			cell.textLabel.text = NSLocalizedString("fromCamera", comment: "")
			cell.indentationLevel = 2
			cell.accessoryType = UITableViewCellAccessoryType.None
		case UIImagePickerControllerSourceType.SavedPhotosAlbum:
			cell.textLabel.text = NSLocalizedString("fromPhotos", comment: "")
			cell.indentationLevel = 2
			cell.accessoryType = UITableViewCellAccessoryType.None
		default:
			break
		}
	}
	
	func configureMediaSources() {
		if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
			self.mediaSources.append(UIImagePickerControllerSourceType.Camera)
		}
		if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
			self.mediaSources.append(UIImagePickerControllerSourceType.PhotoLibrary)
		}
		if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)) {
			self.mediaSources.append(UIImagePickerControllerSourceType.SavedPhotosAlbum)
		}
	}
	
    /*
		// MARK: - UITableViewDataSource and UITableViewDelegate
    */
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return self.mediaSources.count + 1
		default:
			return 0
		}
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let __cell:AnyObject = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
		var cell:UITableViewCell = __cell as UITableViewCell
		
		if (indexPath.section == 0) {
			cell.textLabel.text = NSLocalizedString("selectBackgroundColor", comment:"")
			cell.textLabel.textColor = self.choosedBackgroundColor != nil ? self.choosedBackgroundColor : UIColor.blackColor()
			cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		}
		else if (indexPath.row < self.mediaSources.count) {
			self.configureCell(cell, forSourceType:self.mediaSources[indexPath.row])
		}
		else {
			cell.textLabel.text = NSLocalizedString("delete", comment:"")
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if (section == 1) {
			let result:UIView = UIView(frame:CGRectMake(0.0, 0.0, self.myTableView.bounds.size.width, 50.0))
			let headerLabel:UILabel = UILabel(frame:CGRectMake(15.0, 0.0, result.bounds.size.width - 65.0, 50.0))
			result.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
			headerLabel.text = NSLocalizedString("selectBackgroundImage", comment: "")
			headerLabel.font = UIFont(name:"AvenirNeue-Medium", size: 14.0)
			headerLabel.textColor = UIColor.darkGrayColor()
			result.addSubview(headerLabel)
			if (self.choosenBackgroundImage != nil) {
				let imageView:UIImageView = UIImageView(frame: CGRectMake(headerLabel.frame.origin.x + headerLabel.frame.size.width + 5.0, 5.0, 40.0, 40.0))
				imageView.contentMode = UIViewContentMode.ScaleAspectFill
				imageView.clipsToBounds = true
				imageView.image = self.choosenBackgroundImage
				result.addSubview(imageView)
			}
			return result
		}
		return nil
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 1 ? 50.0 : 0.0
	}
		
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		if ((indexPath.row == 0) && (indexPath.section == 0)) {
			let controller:SelectColorViewController = SelectColorViewController(nibName:"SelectColorViewController", bundle:nil)
			controller.delegate = self
			controller.selectedColor = self.choosedBackgroundColor!
			self.presentViewController(controller, animated: true, completion: nil)
		}
		else if (indexPath.section == 1) {
			if (indexPath.row < self.mediaSources.count) {
				self.handleMediaSelectionAtIndex(indexPath.row, ofCell: tableView.cellForRowAtIndexPath(indexPath)!)
			} else {
				self.deleteCurrentSelectedImage()
			}
		}
	}
	
	
	/*
		// MARK: - button handling
	*/
	
	@IBAction func doneButtonTouched(AnyObject) {
		self.delegate?.settingsViewControllerDidFinishedSuccessfully(self)
	}
	
	func handleMediaSelectionAtIndex(index:Int, ofCell cell:UITableViewCell) {
		switch mediaSources[index] {
		case UIImagePickerControllerSourceType.Camera:
			break
		case UIImagePickerControllerSourceType.PhotoLibrary, UIImagePickerControllerSourceType.SavedPhotosAlbum:
			let controller = UIImagePickerController()
			controller.delegate = self
			controller.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(mediaSources[index])!
			self.popoverController = WEPopoverController(contentViewController: controller)
			self.popoverController.delegate = self
			self.popoverController.popoverContentSize = CGSizeMake(300.0, 380.0)
			self.popoverController.presentPopoverFromRect(self.myTableView.rectForSection(1), inView:self.myTableView, permittedArrowDirections:UIPopoverArrowDirection.Up, animated:true)
		default:
			break
		}
	}
	
	func deleteCurrentSelectedImage() {
		self.choosenBackgroundImage = nil;
		self.myTableView.reloadData()
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
	
	
	/*
		// MARK: - WEPopoverDelegate
	*/
	
	func popoverControllerDidDismissPopover(popoverController: WEPopoverController!) {
		
	}
	
	func popoverControllerShouldDismissPopover(popoverController: WEPopoverController!) -> Bool {
		return true
	}
	
	/*
	 	// MARK: - UIImagePickerViewControllerDelegate
	*/
	
	func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		let image = info[UIImagePickerControllerOriginalImage] as UIImage
		self.choosenBackgroundImage = image
		self.myTableView.reloadData()
		self.popoverController.dismissPopoverAnimated(true)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		self.popoverController.dismissPopoverAnimated(true)
	}
}
