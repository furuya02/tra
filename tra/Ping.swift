//
//  Ping.swift
//  tr
//
//  Created by ShinichiHirauchi on 2015/11/20.
//  Copyright © 2015年 SAPPOROWORKS. All rights reserved.
//

import Foundation

protocol PingDelegate {
    func sended(sendBytes:Int) // 送信完了時
    func recved(recvBytes:Int,srcAddr:String,icmpType:UInt8,msec:NSTimeInterval,id:Int) // 受信完了時
    func err(message:String) // エラー発生時
}

class Ping:NSObject{
    
    var delegate:PingDelegate?

    func send(ipAddr:String, id:Int, ttl:UInt32) -> Int{
        
        //type = ECHO_REQUEST = 8
        var icmpHdr:IcmpHeader = IcmpHeader.init(type: 8, code: 0, sum: 0, id: UInt16(id), seq: UInt16(id))
        icmpHdr.sum = (self.checksum(Cast.ptr(&icmpHdr,len: IcmpHeaderLen) as UnsafePointer<UInt8>, start:0,len:IcmpHeaderLen)).bigEndian
        let sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
        //let sock = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
        if (sock < 0) {
            delegate?.err("socket() faild. sock=\(sock)")
            return -1
        }
        var t = Int32(ttl)
        if( 0 != setsockopt(sock,IPPROTO_IP,IP_TTL,&t,4)){
            delegate?.err("error setsockopt")
            return -1
        }
        // sockaddr_in で宛先アドレス情報を生成
        var sockaddrIn = sockaddr_in()
        sockaddrIn.sin_family = UInt8(AF_INET)
        sockaddrIn.sin_addr.s_addr = inet_addr(ipAddr)
        sockaddrIn.sin_len = UInt8(sizeof(sockaddr_in))
        // sockaddr_in を sockaddr にキャストする
        var addr = (Cast.direct(&sockaddrIn) as sockaddr)
        let addrLen = UInt32(sizeof(sockaddr_in))

        // ICMPパケットの送信
        let startTime = NSDate()

        let sendBytes = sendto(sock, Cast.ptr(&icmpHdr,len: IcmpHeaderLen) as UnsafePointer<UInt8>, IcmpHeaderLen, 0, &addr, addrLen)
        if ( sendBytes < 1 ){
            delegate?.err("ERROR sendto()")
            return -1
        }
        delegate?.sended(sendBytes)
        
        let bufLen = 1600
        var buf = [Int8](count:bufLen,repeatedValue:0) // 受信バッファ
        var packet:NSData
        var ipHeader = IpHeader()
        var recvBytes = 0
        while(true){
            //ICMPパケットの受信
            recvBytes = recv(sock, &buf, bufLen, 0);
        
        
            packet = NSData(bytes: buf, length: recvBytes)
            // IPヘッダのデコード
            ipHeader = UnsafePointer<IpHeader>(packet.subdataWithRange(NSMakeRange(0,IpHeaderLen)).bytes).memory
            // IPヘッダのサイズ取得（ICMPヘッダのオフセットを取得するため）
            let ipHdrlen = Int((ipHeader.verLen & 0x0F)*4)
            // ICMPヘッダのデコード(ICMPヘッダの最初サイズ8オクテットだけ取得する)
            icmpHdr = UnsafePointer<IcmpHeader>(packet.subdataWithRange(NSMakeRange(ipHdrlen,8)).bytes).memory
            
            if(icmpHdr.type==0){
                if( icmpHdr.id == UInt16(id)){
                    // ICMPの
                    //print(String(format:"type==0 seq=%d id =%d break",icmpHdr.seq,icmpHdr.id))
                    break
                }else{
                    //print(String(format:"type==0 seq=%d id =%d",icmpHdr.seq,icmpHdr.id))
                }
            }else if(icmpHdr.type==11){
                // ICMPパケットのデータ領域にある送信データのコピーをデコードする
                // 送信ICMPヘッダ
                let h = UnsafePointer<IcmpHeader>(packet.subdataWithRange(NSMakeRange(20+8+20,8)).bytes).memory
                if(UInt16(id) == h.id){
                    break
                }
            
            }
            
        }
        let msec = NSDate().timeIntervalSinceDate(startTime)

        
        // 送信元IPアドレスのデコード
        let m1 = (ipHeader.srcAddr & 0xFF000000) >> 24
        let m2 = (ipHeader.srcAddr & 0x00FF0000) >> 16
        let m3 = (ipHeader.srcAddr & 0x0000FF00) >> 8
        let m4 = (ipHeader.srcAddr & 0x000000FF)
        let srcAddr = String(format: "%d.%d.%d.%d",m4,m3,m2,m1)

        delegate?.recved(recvBytes, srcAddr: srcAddr, icmpType: icmpHdr.type, msec:msec,id: id)

        return Int(icmpHdr.type)
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
