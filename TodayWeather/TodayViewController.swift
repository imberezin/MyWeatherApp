//
//  TodayViewController.swift
//  TodayWeather
//
//  Created by Israel Berezin on 3/12/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftUI

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
         self.screenDefaultSize()
    }
        
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.screenDefaultSize()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func screenDefaultSize(){
        self.preferredContentSize = CGSize(width:self.view.frame.size.width, height:150)

        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded

    }
    
    @IBSegueAction func addSwiftUIVIew(_ coder: NSCoder) -> UIViewController? {

        return UIHostingController(coder: coder, rootView: WidgetView().background(Color.clear))
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 300)
        }else if activeDisplayMode == .compact{
            self.preferredContentSize = CGSize(width: maxSize.width, height: 150)
        }
    }

}
