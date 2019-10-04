//
//  UIViewExtension.swift
//  Movinfo
//
//  Created by Aydn on 4.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import Foundation
import Lottie

extension UIView
{
    
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
