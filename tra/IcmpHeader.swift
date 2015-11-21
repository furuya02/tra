//
//  IcmpHeader.swift
//  tr
//
//  Created by ShinichiHirauchi on 2015/11/20.
//  Copyright © 2015年 SAPPOROWORKS. All rights reserved.
//

import Foundation

struct IcmpHeader {
    var type:UInt8
    var code:UInt8
    var sum:UInt16
    var id:UInt16
    var seq:UInt16
}

// パケットの最小サイズ64になるように56オクテットのペーロードを追加
let IcmpHeaderLen = Int(sizeof(IcmpHeader))+56