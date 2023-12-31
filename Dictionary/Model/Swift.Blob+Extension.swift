//
//  Swift.Blob+Extension.swift
//  Dictionary
//
//  Created by sdk on 31.12.2023.
//

import Foundation
import SQLite

extension SQLite.Blob {
    init(data: Data) {
        let size = MemoryLayout<UInt8>.stride
        let length = data.count * MemoryLayout<UInt8>.stride
        var bytes = [UInt8](repeating: 0, count: data.count / size)
        (data as NSData).getBytes(&bytes, length: length)
        self.init(bytes: bytes)
    }
}
