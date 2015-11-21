//
//  IpHeader.swift
//  tr
//
//  Created by ShinichiHirauchi on 2015/11/20.
//  Copyright © 2015年 SAPPOROWORKS. All rights reserved.
//

import Foundation

struct IpHeader {
    var verLen:UInt8 = 0
    var type:UInt8 = 0
    var len:UInt16 = 0
    var id:UInt16 = 0
    var flg:UInt16 = 0
    var ttl:UInt8 = 0
    var proto:UInt8 = 0
    var sum:UInt16 = 0
    var srcAddr:UInt32 = 0
    var dstAddr:UInt32 = 0
}

// オプション無しで20オクテットに固定
let IpHeaderLen = Int(sizeof(IpHeader))
