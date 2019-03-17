//
//  AlwaysPopupSegue.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 16/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class AlwaysPopupSegue : UIStoryboardSegue, UIPopoverPresentationControllerDelegate
{
    override init(identifier: String?, source: UIViewController, destination: UIViewController)
    {
        super.init(identifier: identifier, source: source, destination: destination)
        destination.modalPresentationStyle = UIModalPresentationStyle.popover
        destination.popoverPresentationController?.delegate = self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
