//
//  UITabBarControllerExtensions.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 6/4/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

extension UITabBarController {
    func selectViewControllerByClass(_ viewControllerClass: AnyClass) {
        let vc = self.viewControllers?.first(where: { (vc) -> Bool in
            if type(of: vc) == viewControllerClass {
                return true
            } else {
                if let nav = vc as? UINavigationController, type(of: nav.childViewControllers[0]) == viewControllerClass {
                    return true
                }
                return false
            }
        })
        self.selectedViewController = vc
    }
}
