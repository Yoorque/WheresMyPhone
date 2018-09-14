//
//  BackgroundTaskManager.swift
//  WheresMyPhone
//
//  Created by Marko Trajcevic on 9/13/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit

final class BackgroundTaskManager {
    
    static let shared = BackgroundTaskManager()
    
    private var masterId:UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    private var subTaskList:[UIBackgroundTaskIdentifier] = []
    
    public func new() {
        var bgTaskId:UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        bgTaskId = UIApplication.shared.beginBackgroundTask {
            if let index = self.subTaskList.index(of:bgTaskId) {
                self.subTaskList.remove(at: index)
            }
            UIApplication.shared.endBackgroundTask(bgTaskId)
            bgTaskId = UIBackgroundTaskInvalid
        }
        if masterId == UIBackgroundTaskInvalid {
            self.masterId = bgTaskId;
        } else {
            self.subTaskList.append(bgTaskId)
            self.end()
        }
    }
    public func drain() {
        for (index, task) in subTaskList.enumerated() {
            UIApplication.shared.endBackgroundTask(task)
            subTaskList.remove(at: index)
        }
        
        if masterId != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(masterId)
            masterId = UIBackgroundTaskInvalid
        }
    }
    private func end() {
        for (index, task) in self.subTaskList.enumerated() {
            if task != masterId, index != 0 {
                UIApplication.shared.endBackgroundTask(task)
                self.subTaskList.remove(at: index)
            } else {
                print("\(Date())>>>>> subTaskList index 0:\(task)")
            }
        }
    }
    
}
