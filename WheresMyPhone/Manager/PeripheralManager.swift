//
//  PeripheralManager.swift
//  WheresMyPhone
//
//  Created by Marko Trajcevic on 9/12/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import CoreBluetooth


class PeripheralManager: NSObject {
    
    // MARK: - PeripheralManager Properties
    
    fileprivate var dataToSend: Data?
    fileprivate var sendDataIndex: Int?
    fileprivate var characteristic: CBMutableCharacteristic?
    fileprivate var sendingEOM = false

    
    fileprivate var manager: CBPeripheralManager?
    
    
     override init() {
        super.init()
        self.manager = CBPeripheralManager(delegate: self, queue: nil)

    }
    
    
    
    //MARK: - Peripheral - Start Advertising
    
    public func startAdvertising() {
        BackgroundTaskManager.shared.new()
        print("***** startAdvertising has been initiated *****")
        manager?.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey : [serviceUUID]
            ])
    }
    
    // MARK: - PeripheralManager - Stop Advertising
    
    public func stopAdvertising() {
        BackgroundTaskManager.shared.drain()
        print("***** stopAdvertising has been initiated *****")
        manager?.stopAdvertising()
    }
    
    // MARK: - Peripheral Helper Methods
    
    fileprivate func createService() {
        print("******* createService  *********")
        let service = CBMutableService(type: serviceUUID, primary: true)
        characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                 properties: .notify,
                                                 value: nil,
                                                 permissions: .readable)
        
        service.characteristics = [characteristic!]
        manager?.add(service)
    }
    
    fileprivate func cleanUpService() {
        manager?.removeAllServices()
    }
    
    // MARK: - Peripheral Start Sending Data
    
    fileprivate func sendData() {
        if sendingEOM {
            // send it
            let didSend = manager?.updateValue(
                "EOM".data(using: String.Encoding.utf8)!,
                for: characteristic!,
                onSubscribedCentrals: nil
            )
            
            // Did it send?
            if (didSend == true) {
                print("didSend: \(String(describing: didSend))")
                // It did, so mark it as sent
                sendingEOM = false
                
                print("Sent: EOM")
            }
            
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        // We're not sending an EOM, so we're sending data
        
        // Is there any left to send?
        guard sendDataIndex! < (dataToSend?.count)!
          else {
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        var didSend = true
        
        while didSend {
            // Make the next chunk
            
            // Work out how big it should be
            print("dataToSend: type data:",dataToSend!)
            var amountToSend = dataToSend!.count - sendDataIndex!;
            
            // Can't be longer than 20 bytes
            if (amountToSend > NOTIFY_MTU) {
                amountToSend = NOTIFY_MTU;
            }
            
            // Copy out the data we want
            let chunk = dataToSend!.withUnsafeBytes{(body: UnsafePointer<UInt8>) in
                return Data(
                    bytes: body + sendDataIndex!,
                    count: amountToSend
                )
            }
            
            // Send it
            didSend = (manager?.updateValue(
                chunk as Data,
                for: characteristic!,
                onSubscribedCentrals: nil
                ))!
            print("chunk of data: \(chunk)")
            
            
            // If it didn't work, drop out and wait for the callback
            if (!didSend) {
                return
            }
            
            let stringFromData = NSString(
                data: chunk as Data,
                encoding: String.Encoding.utf8.rawValue
            )
            
            print("Sent: \(String(describing: stringFromData))")
            
            // It did send, so update our index
            sendDataIndex! += amountToSend;
            
            // Was it the last one?
            if (sendDataIndex! >= dataToSend!.count) {
                
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                sendingEOM = true
                
                // Send it
                let eomSent = manager?.updateValue(
                    "EOM".data(using: String.Encoding.utf8)!,
                    for: characteristic!,
                    onSubscribedCentrals: nil
                )
                
                if (eomSent)! {
                    // It sent, we're all done
                    sendingEOM = false
                    print("Sent: EOM")
                }
                
                return
            }
        }
    }
}

//MARK: - PeripheralManager Delegate

extension PeripheralManager: CBPeripheralManagerDelegate {
    
     func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("PERIPHERAL_MANAGER: didUpdateState ****** peripheral.unkown *********")
            cleanUpService()
        case .resetting:
            print("PERIPHERAL_MANAGER: didUpdateState ****** peripheral.resetting *********")
            cleanUpService()
        case .unsupported:
            print("PERIPHERAL_MANAGER: didUpdateState ****** peripheral.unsuppoorted *********")
            cleanUpService()
        case .unauthorized:
            print("PERIPHERAL_MANAGER: didUpdateState ****** peripheral.unauthorized *********")
            cleanUpService()
        case .poweredOff:
            print("PERIPHERAL_MANAGER: didUpdateState ****** peripheral.powerOff *********")
            cleanUpService()
        case .poweredOn:
            print("PERIPHERAL_MANAGER: didUpdateState ****** peripheral.powerOn *********")
            createService()
        }
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("PERIPHERAL_MANAGER: didSubscribeTO \(characteristic.description)")
        // Get the data
        dataToSend = "saljeeee".data(using: String.Encoding.utf8)
        
        // Reset the index
        sendDataIndex = 0
        
        // Start sending
        sendData()
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("PERIPHERAL_MANAGER: didUnsubscribeFrom \(characteristic.description)")
    }
    // This call backs comes when PeripheralManager is ready to send next chunk of data
    //THis is to ensure that packets will arrive in the order that they are sent
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        print("PERIPHERAL_MANAGER: toUpdateSubscribers ****** \(peripheral.isAdvertising)")
        //Start sending again
        sendData()
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("PERIPHERAL_MANAGER: didStartAdvertising --- ERROR:  \(String(describing: error?.localizedDescription))")
    }
    

}
