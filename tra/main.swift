//
//  main.swift
//  tra
//
//  Created by ShinichiHirauchi on 2015/11/22.
//  Copyright © 2015年 SAPPOROWORKS. All rights reserved.
//

import Foundation

class Main:PingDelegate{
    
    var _args:[String]
    var isFinish = false // 終了フラグ
    var results:[Result] = [] // 結果取得用配列
    var max = 30 // 最大ホップ数（スレッド多重数）
    
    
    init(args:[String]){
        _args = args
    }
    
    func run(){
        //第１パラメータが宛先ホスト名
        var ar = NetName.toAddr(_args[1]) // IPアドレスへの変換
        let ipAddr = ar[0] // 複数ある場合は、最初のアドレスを使用する
        
        print("traceroute to \(_args[1]) (\(ipAddr)), \(max) hops max, 52byte packets")
        
        // 結果取得用の配列を用意する
        for _ in 0 ... max {
            results.append(Result())
        }
        
        // コンカレントキューの生成
        let queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT)
        
        let ping = Ping()
        ping.delegate = self
        // 多重スレッドでTTLの違うICMPを送信する
        for i in 0 ... max {
            dispatch_async(queue, {
                ping.send(ipAddr, id: i, ttl: UInt32(i+1))
            })
        }
        // type=0のパケットを受け取るまで待機
        while(!isFinish){
            sleep(0)
        }
        // 表示
        for i in 0 ... max {
            let r = results[i]
            if(r.srcAddr=="*"){
                print(String(format: "%d *",i+1))
            }else{
                print(String(format: "%d %@ (%@) %.3f ms",i+1,r.hostName,r.srcAddr,r.msec*1000))
                
            }
            if(r.icmpType==0){
                break
            }
        }
    }
    // 送信完了
    func sended(bytes:Int) {
        //print("\(bytes)byte sended.")
    }
    // 受信完了
    func recved(recvBytes: Int, srcAddr: String, icmpType: UInt8, msec: NSTimeInterval, id: Int) {
        
        // 結果取得用の配列に格納する
        var host = NetName.toHost(srcAddr)
        results[id].hostName = host[0]
        results[id].srcAddr = srcAddr
        results[id].icmpType = icmpType
        results[id].msec = msec
        
        //DEBUG
        //print("recved \(srcAddr) type=\(icmpType) id=\(id)")
        
        if (icmpType == 0){
            // 到達のパケットを受けてから100msだけ待機する
            usleep(100000)
            isFinish = true // 終了フラグを立てる
        }
        
    }
    // エラー発生
    func err(message:String) {
        print("ERROR : \(message)")
    }
    
}

var args = NSProcessInfo.processInfo().arguments
if args.count != 2 {
    print("Usage: tr host")
    exit(-1)
}

Main.init(args: args).run()
