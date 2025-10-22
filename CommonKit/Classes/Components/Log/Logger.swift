//
//  Logger.swift
//  CommomKit
//
//  Created by wangpengyun on 2025/10/22.
//

import Foundation
import os

public final class Logger {
    private let subsystem: String
    private let category: String
    private let oslog: OSLog
    
    init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.commonkit.logger",
         category: String) {
        self.subsystem = subsystem
        self.category = category
        self.oslog = OSLog(subsystem: subsystem, category: category)
    }
    
    public func info(_ message: String) {
        os_log("%{public}@", log: oslog, type: .info, message)
    }
    
    public func debug(_ message: String) {
        os_log("%{public}@", log: oslog, type: .debug, message)
    }
    
    public func error(_ message: String) {
        os_log("%{public}@", log: oslog, type: .error, message)
    }
}
