//
//  UIViewControllerExtensions.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 2/4/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    typealias KeyboardHeightClosure = (CGFloat) -> ()
    
    func addKeyboardChangeFrameObserver(willShow willShowClosure: KeyboardHeightClosure?,
                                        willHide willHideClosure: KeyboardHeightClosure?) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil, queue: OperationQueue.main, using: { [weak self](notification) in
            if let userInfo = notification.userInfo,
                let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
                let c = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
                let kFrame = self?.view.convert(frame, from: nil),
                let kBounds = self?.view.bounds {
                
                let animationType = UIViewAnimationOptions(rawValue: c)
                let kHeight = kFrame.size.height
                UIView.animate(withDuration: duration, delay: 0, options: animationType, animations: {
                    if kBounds.intersects(kFrame) { // keyboard will be shown
                        willShowClosure?(kHeight)
                    } else { // keyboard will be hidden
                        willHideClosure?(kHeight)
                    }
                }, completion: nil)
            } else {
                print("Invalid conditions for UIKeyboardWillChangeFrameNotification")
            }
        })
    }
    
    func removeKeyboardChangeFrameObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}
