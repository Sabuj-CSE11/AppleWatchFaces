//
//  DecoratorTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 12/2/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import UIKit

class DecoratorTextTableViewCell: DecoratorTableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var fontTitleLabel: UILabel!
    @IBOutlet var valueSlider: UISlider!
    @IBOutlet var rotatingSwitch: UISwitch!
    @IBOutlet var materialSegment: UISegmentedControl!
    @IBOutlet var totalNumbersSegment: UISegmentedControl!
    
    func myClockRingSetting()->ClockRingSetting {
        return (SettingsViewController.currentClockSetting.clockFaceSettings?.ringSettings[rowIndex])!
    }
    
    @IBAction func totalSegmentDidChange(sender: UISegmentedControl ) {
        let clockRingSetting = myClockRingSetting()
        clockRingSetting.ringPatternTotal = Int(ClockRingSetting.ringTotalOptions()[sender.selectedSegmentIndex])!
        clockRingSetting.ringPattern = [1] // all on for now
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"ringPatternTotal" ])
    }
    
    @IBAction func segmentDidChange(sender: UISegmentedControl ) {
        //debugPrint("segment value:" + String( sender.selectedSegmentIndex ) )
        let clockRingSetting = myClockRingSetting()
        clockRingSetting.ringMaterialDesiredThemeColorIndex = sender.selectedSegmentIndex
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"ringMaterialDesiredThemeColorIndex" ])
    }
    
    @IBAction func switchDidChange(sender: UISwitch ) {
        //debugPrint("switch value:" + String( sender.isOn ) )
        let clockRingSetting = myClockRingSetting()
        if sender.isOn {
            clockRingSetting.ringType = .RingTypeTextNode
        } else {
            clockRingSetting.ringType = .RingTypeTextRotatingNode
        }
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"textType" ])
    }
    
    @IBAction func sliderValueDidChange(sender: UISlider ) {
        //debugPrint("slider value:" + String( sender.value ) )
        let clockRingSetting = myClockRingSetting()
        
        let roundedValue = Float(round(100*sender.value)/100)
        if roundedValue != clockRingSetting.textSize {
            //debugPrint("new value:" + String( roundedValue ) )
            clockRingSetting.textSize = roundedValue
            NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                            userInfo:["settingType":"textSize" ])
        }
        
        
        
    }
    
    override func setupUIForClockRingSetting() {
        super.setupUIForClockRingSetting()
        
        let clockRingSetting = myClockRingSetting()
        
        self.titleLabel.text = ClockRingSetting.descriptionForRingType(clockRingSetting.ringType)
        self.fontTitleLabel.text =  NumberTextNode.descriptionForType(clockRingSetting.textType)
        self.materialSegment.selectedSegmentIndex = clockRingSetting.ringMaterialDesiredThemeColorIndex
        
        //TODO: set total to proper index
        //self.totalNumbersSegment.selectedSegmentIndex = ClockRingSetting.ringTotalOptions()
        
        
        if clockRingSetting.ringType == .RingTypeTextRotatingNode {
            self.rotatingSwitch.isOn = true
        } else {
            self.rotatingSwitch.isOn = false
        }
        
        if clockRingSetting.ringType == .RingTypeTextNode || clockRingSetting.ringType == .RingTypeTextRotatingNode {
            valueSlider.minimumValue = AppUISettings.ringSettigsSliderTextMin
            valueSlider.maximumValue = AppUISettings.ringSettigsSliderTextMax
            
            valueSlider.value = clockRingSetting.textSize
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
