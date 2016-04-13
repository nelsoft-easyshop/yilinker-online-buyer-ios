//
//  CountryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 4/13/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 
    //MARK: - Country Button Action
    @IBAction func countryButtonAction(sender: UIButton) {
        
        var alertView: LGAlertView = LGAlertView(title: "Select a Country", message: "Please choose your prefered country to buy a product.", style: LGAlertViewStyle.ActionSheet, buttonTitles: ["Phlippines", "China"], cancelButtonTitle: nil, destructiveButtonTitle: nil, actionHandler: nil, cancelHandler: nil, destructiveHandler: nil)
        
        alertView.coverColor = UIColor(white: 1.0, alpha: 0.9)
        alertView.layerShadowColor = UIColor(white: 0.0, alpha: 0.3)
        alertView.layerShadowRadius = 4.0
        alertView.layerCornerRadius = 0.0
        alertView.layerBorderWidth = 2.0
        alertView.layerBorderColor = Constants.Colors.appTheme
        alertView.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        alertView.buttonsHeight = 44.0
        alertView.titleFont = UIFont.boldSystemFontOfSize(18.0)
        alertView.titleTextColor = UIColor.blackColor()
        alertView.messageTextColor = UIColor.blackColor()
        alertView.width = min(self.view.bounds.size.width, self.view.bounds.size.height)
        alertView.offsetVertical = 0.0
        alertView.cancelButtonOffsetY = 0.0
        alertView.titleTextAlignment = .Left
        alertView.messageTextAlignment = .Left
        alertView.destructiveButtonTextAlignment = .Right
        alertView.buttonsTextAlignment = .Right
        alertView.cancelButtonTextAlignment = .Right
        alertView.separatorsColor = nil
        alertView.destructiveButtonTitleColor = UIColor.whiteColor()
        alertView.buttonsTitleColor = UIColor.whiteColor()
        alertView.cancelButtonTitleColor = UIColor.whiteColor()
        alertView.destructiveButtonBackgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        alertView.buttonsBackgroundColor = Constants.Colors.alphaAppThemeColor
        alertView.buttonsBackgroundColorHighlighted = Constants.Colors.appTheme
        alertView.cancelButtonBackgroundColorHighlighted = UIColor(white: 0.5, alpha: 1.0)
        alertView.showAnimated(true, completionHandler: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
