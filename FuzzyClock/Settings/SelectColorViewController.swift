//
//  SelectColorViewController.swift
//  FuzzyClock
//
//  Created by Andre Hess on 25.11.14.
//  Copyright (c) 2014 Andre Hess. All rights reserved.
//

import UIKit


protocol ColorSelectionProtocol {
	func selectColorViewControllerFinishedSuccessfully(SelectColorViewController)
}


class SelectColorViewController: UIViewController {

	@IBOutlet weak var redLabel:UILabel!
	@IBOutlet weak var greenLabel:UILabel!
	@IBOutlet weak var blueLabel:UILabel!
	@IBOutlet weak var resultLabel:UILabel!
	@IBOutlet weak var redValueSlider:UISlider!
	@IBOutlet weak var greenValueSlider:UISlider!
	@IBOutlet weak var blueValueSlider:UISlider!
	@IBOutlet weak var resultView:UIView!
	@IBOutlet weak var myNavigationBar:UINavigationBar!
	@IBOutlet weak var myNavigationItem:UINavigationItem!
	
	@IBAction func doneButtonTouched(AnyObject) {
		self.delegate?.selectColorViewControllerFinishedSuccessfully(self)
	}
	
	@IBAction func colorSliderValueChanged(AnyObject) {
		let red:CGFloat = CGFloat(self.redValueSlider.value)
		let green:CGFloat = CGFloat(self.greenValueSlider.value)
		let blue:CGFloat = CGFloat(self.blueValueSlider.value)
		self.selectedColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
		self.configureResultView()
	}
	
	var selectedColor:UIColor?
	var delegate:ColorSelectionProtocol?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.configureNavigationBar()
		self.configureLabels()
		self.configureSliders()
		self.configureResultView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	/*
	// MARK: - navibar
	*/
	
	func configureNavigationBar() {
		var navigationBarFrame = self.myNavigationBar.frame
		navigationBarFrame.size.height = 64.0
		self.myNavigationBar.frame = navigationBarFrame
		
		self.myNavigationItem.title = NSLocalizedString("colorSelection", comment: "")
	}
	
	/*
	// MARK: - labels
	*/
	
	func configureLabels() {
		self.redLabel.text = NSLocalizedString("redValue", comment:"")
		self.greenLabel.text = NSLocalizedString("greenValue", comment:"")
		self.blueLabel.text = NSLocalizedString("blueValue", comment:"")
		self.resultLabel.text = NSLocalizedString("resultColor", comment:"")
	}
	
	/*
	// MARK: - sliders
	*/
	
	func configureSliders() {
		let colorComponents:UnsafePointer<CGFloat> = self.getRedGreenAndBlueFromColor(self.selectedColor!)
		let red:Float = Float(colorComponents[0])
		let green:Float = Float(colorComponents[1])
		let blue:Float = Float(colorComponents[2])
		self.redValueSlider.value = red
		self.greenValueSlider.value = green
		self.blueValueSlider.value = blue
	}
	
	func getRedGreenAndBlueFromColor(color:UIColor) -> UnsafePointer<CGFloat> {
		let colorRef:CGColorRef = color.CGColor
		var components:UnsafePointer<CGFloat>
		components = CGColorGetComponents(colorRef)
		return components
	}
    

    /*
    // MARK: - ResultView
	*/
	
	func configureResultView() {
		self.resultView.backgroundColor = self.selectedColor!
	}

}
