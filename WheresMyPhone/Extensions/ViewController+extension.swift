//
//  ViewController+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/6/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import GoogleMaps

//MARK: - tableViewDelegate and tableViewDataSource -
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceManager.devices.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeviceCell
        cell.nameLabel.text = deviceManager.devices.value[indexPath.row].name
        cell.movesLabel.text = "\(deviceManager.devices.value[indexPath.row].coordinates.value.count)"
        return cell
    }
    
    
    //Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        trackCoordinateObservable.onNext(deviceManager.devices.value[indexPath.row].coordinates.value.last!)        
    } 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _,_,_ in
            self.selectedRow = 0
            self.deviceManager.devices.value.remove(at: indexPath.row)
           // tableView.deleteRows(at: [indexPath], with: .left)
            self.tableView.reloadData()
        })
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}
