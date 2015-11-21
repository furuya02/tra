//
//  Name.swift
//  tr
//
//  Created by ShinichiHirauchi on 2015/11/20.
//  Copyright © 2015年 SAPPOROWORKS. All rights reserved.
//

import Foundation

class NetName{

    class func toHost(ipAddr:String)->[String]{
        let host = NSHost(address: ipAddr)
        if(host.names.count>0){
            return host.names
        }
        return [ipAddr]
    }
    
    class func toAddr(hostname:String)->[String]{

        let host = NSHost(name: hostname)
        
        // 対象をIPv4アドレスのみに制限する
        var ar:[String]=[]
        for a in host.addresses {
            if( a.componentsSeparatedByString(".").count == 4 ){
                ar.append(a)
            }
        }
        return ar

        //-------------------------------------------
        //addrinfo によるIPアドレス取得
        //-------------------------------------------
//        var ar:[String]=[]
//        var buf = [Int8](count:128,repeatedValue:0) // 文字列化するためのテンポラリ
//        
//        var hints = addrinfo(ai_flags: 0, ai_family: AF_INET, ai_socktype: SOCK_STREAM, ai_protocol: IPPROTO_TCP, ai_addrlen: 0, ai_canonname: nil, ai_addr: nil, ai_next: nil)
//    
//        var result = UnsafeMutablePointer<addrinfo>(nil)
//        let error = getaddrinfo(hostname, UnsafePointer<Int8>(), &hints, &result)
//        if(error == 0) {
//            var res = result
//            while( res != nil ){
//                if( res.memory.ai_family == AF_INET ){
//                    var sockaddrIn = Cast.direct(res.memory.ai_addr) as sockaddr_in
//                    inet_ntop(AF_INET,&sockaddrIn.sin_addr, &buf, 128)
//                    ar.append(String.fromCString(buf)!)
//                }
//                res = res.memory.ai_next
//            }
//            freeaddrinfo(result)
//        }
//        return ar
    }
}