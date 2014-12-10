//
//  NSString+FuzzyTimeConverting.swift
//  FuzzyClock
//
//  Created by Andre Hess on 25.11.14.
//  Copyright (c) 2014 Andre Hess. All rights reserved.
//

import Foundation

extension NSObject {
	
	func convertTimeToFuzzy(date:NSDate) -> NSString {
		let stringValue = self.getTimeAsString(date)
		var hours = self.getHoursFromTimeAsString(stringValue)
		var minutes = self.getMinutesFromTimeAsString(stringValue)
		
		var incrementHours:Bool = false
		var swapTexts:Bool	 = false
		let minutesFuzzy = self.getMinutesFuzzyStringFromHours(minutes, incrementHours: &incrementHours, swapTexts: &swapTexts)
		if (incrementHours) {
			hours++
		}
		let hoursFuzzy = self.getHoursFuzzyStringFromHours(hours)
		
		return swapTexts ? "\(hoursFuzzy)\(minutesFuzzy)" : "\(minutesFuzzy)\(hoursFuzzy)"
	}
	
	func getCurrentTime() -> String {
		
		let now = NSDate()
		let formatter = NSDateFormatter()
		
		formatter.timeStyle = .MediumStyle
		return formatter.stringFromDate(now)
	}

	/*
		// MARK: - helper functions
	*/
	
	func getTimeAsString(date:NSDate) -> String {
	
		let formatter = NSDateFormatter()
		
		formatter.timeStyle = .MediumStyle
		let loc = NSLocale.currentLocale()
		formatter.locale = NSLocale(localeIdentifier: "de_DE")
		return formatter.stringFromDate(date)
	}
	
	func getHoursFromTimeAsString(timeAsString: String) -> Int32 {
		
		let components = timeAsString.componentsSeparatedByString(":")
		let hoursStringValue: NSString = components[0]
		
		return hoursStringValue.intValue
	}
	
	func getMinutesFromTimeAsString(timeAsString: String) -> Int32 {
		
		let components = timeAsString.componentsSeparatedByString(":")
		let minutesStringValue: NSString = components[1]
		
		return minutesStringValue.intValue
	}

	func getHoursFuzzyStringFromHours(hoursIntValue: Int32) -> String {
		var hoursFuzzy:NSString = ""
		
		switch hoursIntValue {
		case 1, 13:
			hoursFuzzy = NSLocalizedString("1", comment: "")
		case 2, 14:
			hoursFuzzy = NSLocalizedString("2", comment: "")
		case 3, 15:
			hoursFuzzy = NSLocalizedString("3", comment: "")
		case 4, 16:
			hoursFuzzy = NSLocalizedString("4", comment: "")
		case 5, 17:
			hoursFuzzy = NSLocalizedString("5", comment: "")
		case 6, 18:
			hoursFuzzy = NSLocalizedString("6", comment: "")
		case 7, 19:
			hoursFuzzy = NSLocalizedString("7", comment: "")
		case 8, 20:
			hoursFuzzy = NSLocalizedString("8", comment: "")
		case 9, 21:
			hoursFuzzy = NSLocalizedString("9", comment: "")
		case 10, 22:
			hoursFuzzy = NSLocalizedString("10", comment: "")
		case 11, 23:
			hoursFuzzy = NSLocalizedString("11", comment: "")
		default:
			hoursFuzzy = NSLocalizedString("12", comment: "")
		}
		
		return hoursFuzzy
	}
	
	func getMinutesFuzzyStringFromHours(minutesIntValue: Int32, inout incrementHours: Bool, inout swapTexts: Bool) -> String {
		
		var minutesFuzzy = ""
		incrementHours = self.shouldIncrementHours(minutesIntValue)
		swapTexts = self.shouldSwapTextsAtMinutes(minutesIntValue)
		
		if (minutesIntValue == 0) {
			minutesFuzzy = NSLocalizedString("at", comment: "")
		}
		else if ((minutesIntValue > 0) && (minutesIntValue <= 3)) {
			minutesFuzzy = NSLocalizedString("short after", comment: "")
		}
		else if ((minutesIntValue > 3) && (minutesIntValue <= 7)) {
			minutesFuzzy = NSLocalizedString("five after", comment: "")
		}
		else if ((minutesIntValue > 7) && (minutesIntValue <= 13)) {
			minutesFuzzy = NSLocalizedString("ten after", comment: "")
		}
		else if ((minutesIntValue > 13) && (minutesIntValue <= 18)) {
			minutesFuzzy = NSLocalizedString("fivteen after", comment: "")
		}
		else if ((minutesIntValue > 18) && (minutesIntValue <= 23)) {
			minutesFuzzy = NSLocalizedString("twenty after", comment: "")
		}
		else if ((minutesIntValue > 23) && (minutesIntValue <= 28)) {
			minutesFuzzy = NSLocalizedString("twenty five after", comment: "")
		}
		else if ((minutesIntValue > 28) && (minutesIntValue <= 33)) {
			minutesFuzzy = NSLocalizedString("half", comment: "")
		}
		else if ((minutesIntValue > 33) && (minutesIntValue <= 38)) {
			minutesFuzzy = NSLocalizedString("twenty five before", comment: "")
		}
		else if ((minutesIntValue > 38) && (minutesIntValue <= 43)) {
			minutesFuzzy = NSLocalizedString("twenty before", comment: "")
		}
		else if ((minutesIntValue > 43) && (minutesIntValue <= 48)) {
			minutesFuzzy = NSLocalizedString("fiveteen before", comment: "")
		}
		else if ((minutesIntValue > 48) && (minutesIntValue <= 53)) {
			minutesFuzzy = NSLocalizedString("ten before", comment: "")
		}
		else if ((minutesIntValue > 53) && (minutesIntValue <= 58)) {
			minutesFuzzy = NSLocalizedString("five before", comment: "")
		}
		else if (minutesIntValue > 58) {
			minutesFuzzy = NSLocalizedString("short before", comment: "")
		}
		
		return minutesFuzzy
	}
	
	func shouldIncrementHours(minutesIntValue: Int32) -> Bool {
		var currentLocale:NSLocale = NSLocale.currentLocale();
		var currentLocaleIdentifier:NSString = currentLocale.localeIdentifier;
		if (currentLocaleIdentifier.isEqualToString("en_US")) {
			return minutesIntValue > 33;
		}
		else if (currentLocaleIdentifier.isEqualToString("de_DE")) {
			return minutesIntValue >= 15;
		}
		return false;
	}
	
	func shouldSwapTextsAtMinutes(minutesIntValue: Int32) -> Bool {
		var currentLocale:NSLocale = NSLocale.currentLocale();
		var currentLocaleIdentifier:NSString = currentLocale.localeIdentifier;
		if (currentLocaleIdentifier.isEqualToString("en_US")) {
			return minutesIntValue == 0;
		}
		return false;
	}
}
