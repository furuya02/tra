//
//  Icmp.swift
//  tr
//
//  Created by ShinichiHirauchi on 2015/11/18.
//  Copyright © 2015年 SAPPOROWORKS. All rights reserved.
//

import Foundation

/*
class IcmpPacket:NSObject{
    
    
    func create(){
    
        var sock:Int32
    
        //type = ECHO_REQUEST = 8
        var icmpHdr:IcmpHeader = IcmpHeader.init(type: 8, code: 0, sum: 0, id: 3000, seq: 4000)
        //let icmpHdrLen = Int(sizeof(IcmpHeader))
        icmpHdr.sum = (self.checksum(Cast.ptr(&icmpHdr,len: IcmpHeaderLen) as UnsafePointer<UInt8>, start:0,len:IcmpHeaderLen)).bigEndian
        print(NSString(format: "checksum=0x%x",icmpHdr.sum))
    
        sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
        if (sock < 0) {
            perror("create socket faild.");
        }

        var sockaddrIn:sockaddr_in = sockaddr_in()
        sockaddrIn.sin_family = UInt8(AF_INET)
        //sockaddrIn.sin_addr.s_addr = inet_addr("173.194.126.180")
        sockaddrIn.sin_addr.s_addr = inet_addr("10.255.26.254")
        sockaddrIn.sin_len = UInt8(sizeof(sockaddr_in))
        var addr = (Cast.direct(&sockaddrIn) as sockaddr)
        let addrLen = UInt32(sizeof(sockaddr_in))
    
        let bytes = sendto(sock, Cast.ptr(&icmpHdr,len: IcmpHeaderLen) as UnsafePointer<UInt8>, IcmpHeaderLen, 0, &addr, addrLen)
        if ( bytes < 1 ){
            print("ERROR sendto()")
        }
        print("bytes = \(bytes)")

        //ICMPパケットの受信
        var buf = [Int8](count:Int(1600),repeatedValue:0)
        let n = recv(sock, &buf, 1600, 0);
    print("recv \(n)bytes")

    var packet = NSData(bytes: buf, length: n)
    
    //let ipHdrLen = Int(sizeof(IpHeader))
    
    var ipHdr = UnsafePointer<IpHeader>(packet.subdataWithRange(NSMakeRange(0,IpHeaderLen)).bytes).memory
    let ipHdrlen = (ipHdr.verLen & 0x0F)*5
    icmpHdr = UnsafePointer<IcmpHeader>(packet.subdataWithRange(NSMakeRange(20,IcmpHeaderLen)).bytes).memory
    
    let m1 = (ipHdr.srcAddr & 0xFF000000) >> 24
    let m2 = (ipHdr.srcAddr & 0x00FF0000) >> 16
    let m3 = (ipHdr.srcAddr & 0x0000FF00) >> 8
    let m4 = (ipHdr.srcAddr & 0x000000FF)
    let srcAddr = NSString(format: "%d.%d.%d.%d",m4,m3,m2,m1)
    print(NSString(format: "addr=%@ code=%d id=%d",srcAddr,icmpHdr.code,icmpHdr.id))
    
        
    }
    
    func checksum(buf:UnsafePointer<UInt8>,start:Int,len:Int) -> UInt16 {
        var sum:UInt32 = 0
        var d:UInt16

        // Swiftでは、ビットシフトでオーバーフローすると例外が発生するので、いったんUInt8をUInt16に変換してから作業する
        for ( var i = start; i < ( len + start ); i += 2) {
            if (i + 1 >= len + start) {
                d = ( UInt16(buf[i]) << 8 ) & 0xFF00
            } else {
                d = (((UInt16(buf[i]) << 8) & 0xFF00) + (UInt16(buf[i + 1]) & 0xFF))
            }
            sum += UInt32(d);
        }
        while ((sum >> 16) != 0) {
            sum = (sum & 0xFFFF) + (sum >> 16);
        }
        sum = ~sum
        return UInt16(sum & 0xFFFF)
    }
}

*/