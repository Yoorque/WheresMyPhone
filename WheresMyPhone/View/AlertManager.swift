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
    static func showAlertWith(_ message: String, inViewController vc: ViewController) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButtonAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
