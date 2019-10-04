//
//  ViewController.swift
//  Movinfo
//
//  Created by Aydn on 1.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import UIKit
import Firebase
import Network

class SplashViewController: UIViewController {
    
    @IBOutlet var loodosTextLabel: UILabel!
    var shouldGotoMainPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loodosTextLabel.text = ""
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                if self.shouldGotoMainPage
                {
                    print("Fetching!")
                    self.fetchRemoteConfig()
                    self.shouldGotoMainPage = false
                }
            } else {
                print("No connection.")
                if self.shouldGotoMainPage
                {
                    DispatchQueue.main.async {
                        self.loodosTextLabel.text = "No internet connection."
                    }
                }
            }

            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    private func fetchRemoteConfig(){
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { (status, err) in
            guard err == nil else{ return }
            
            RemoteConfig.remoteConfig().activate(completionHandler: nil)//activateFetched()
            
            if let splashLabelText = RemoteConfig.remoteConfig().configValue(forKey: "loodosText").stringValue{
                let animation = {
                    self.loodosTextLabel.text = splashLabelText
                }
                UIView.transition(with: self.loodosTextLabel, duration: 3, options: .transitionCrossDissolve, animations: animation, completion: { _ in
                    self.performSegue(withIdentifier: "showMainPageSegue", sender: nil)
                })
                    
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
//                    self.performSegue(withIdentifier: "showMainPageSegue", sender: nil)
//                })
            }
        }
    }
}

