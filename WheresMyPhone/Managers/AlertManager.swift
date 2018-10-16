//
//  AlertManager.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/5/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import UIKit

struct AlertManager {
    
    
    static func errorAlert(withError error: WMPError ,_ viewController: ViewController) {
        let alert = UIAlertController(title: "Warning", message: error.recoveryInstruction, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        viewController.present(alert, animated: true, completion: nil)
    }
}
