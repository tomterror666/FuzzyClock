//
//  FuzzyLabel.swift
//  FuzzyClock
//
//  Created by Andre Hess on 31.10.14.
//  Copyright (c) 2014 Andre Hess. All rights reserved.
//


import UIKit

class FuzzyLabel: UILabel {
	
	var textColorComputed:Bool = false
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.textColorComputed = false
		self.setNeedsDisplay()
	}
	
	override func drawTextInRect(rect: CGRect) {
		
		if (!self.textColorComputed) {
			self.textColorComputed = true
			
			let superLayer:CALayer = self.superview!.layer
			let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()!
			let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
			
			let superWidth:UInt = UInt(superLayer.bounds.size.width)
			let superHeight:UInt = UInt(superLayer.bounds.size.height)
			let bitsPerComponent = UInt(8)
			let bytesPerRow = UInt(superWidth * 4)
			let myX:Int = Int(self.convertRect(rect, toView:self.superview).origin.x)
			let myY:Int = Int(self.convertRect(rect, toView:self.superview).origin.y)
			
			var data:UnsafeMutablePointer<CUnsignedChar>
			data = UnsafeMutablePointer<CUnsignedChar>.alloc(Int(bytesPerRow) * Int(superHeight))
			
			let bitmapContext:CGContext = CGBitmapContextCreate(data, superWidth, superHeight, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)
			
			superLayer.renderInContext(bitmapContext)
			
			var overallLightness:Float = 0.0
			var pixelCounter:Int
			var lineCounter:Int
			
			var commonRed:UInt = 0
			var commonGreen:UInt = 0
			var commonBlue:UInt = 0
			
			for lineCounter = myY; lineCounter < Int(rect.size.height) + myY; lineCounter++ {
				
				let redLineStart:Int = Int(superWidth) * lineCounter + myX * 4;
				let redLineEnd:Int = 4 * Int(rect.size.width) + redLineStart;
				
				for pixelCounter = redLineStart; pixelCounter < redLineEnd; pixelCounter += 4 {
					let red:UInt = UInt(data[pixelCounter])
					let green:UInt = UInt(data[pixelCounter + 1])
					let blue:UInt = UInt(data[pixelCounter + 2])
					let alpha:UInt = UInt(data[pixelCounter + 3])
					
					var minimum:UInt = min(red, green)
					minimum = min(minimum, blue)
					var maximum:UInt = max(red, green)
					maximum = max(maximum, blue)
					
					let lightness:Float = Float(maximum + minimum) / 510.0
					//let lightness:Float = Float(maximum) / 255.0
					//let lightness:Float = (Float(red + green + blue) / 3.0) / 255.0
					overallLightness += lightness
					
					commonRed += red
					commonGreen += green
					commonBlue += blue
				}
			}
			
			overallLightness /= Float(rect.size.width) * Float(rect.size.height)
			
			commonRed /= UInt(rect.size.width) * UInt(rect.size.height)
			commonGreen /= UInt(rect.size.width) * UInt(rect.size.height)
			commonBlue /= UInt(rect.size.width) * UInt(rect.size.height)
			
			NSLog("Computed text color with white value for label: 0x%08p is: %.04f", self, 1.0 - overallLightness)
			overallLightness = overallLightness > 0.5 ? 0.90 : 0.05
			NSLog("using text color with white value for label: 0x%08p is: %.04f", self, 1.0 - overallLightness)
			var textColor:UIColor = UIColor(white:CGFloat(1 - overallLightness), alpha:1.0)
	//		var textColor:UIColor = UIColor(red: 1.0 - CGFloat(commonRed)/255.0, green: 1.0 - CGFloat(commonGreen)/255.0, blue: 1.0 - CGFloat(commonBlue)/255.0, alpha: 1.0)
			
			self.textColor = textColor
			
			data.dealloc(Int(bytesPerRow) * Int(superHeight))
		}
		
		super.drawTextInRect(rect)
	}

}
