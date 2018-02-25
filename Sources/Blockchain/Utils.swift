//
//  Utils.swift
//  BlockchainNode
//
//  Created by miroslav on 2/13/18.
//
import Foundation
import PerfectCrypto

struct BCAddress {
    let address: String
}

class Utils {
    
    static func genesisBlock() -> Block {
        return Block(
            index: 0,
            nonce: 1,
            previousHash: [1,0,0,0],
            transactions: []
        )
    }
    
    static func hashToString(_ hash: [UInt8]) -> String {
        let data = Data(bytes: hash).base64EncodedData()
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}


extension UInt {
    func toUInt8Array() -> Array<UInt8> {
        var intNumber = self
        var array: [UInt8] = []
        while intNumber > 0 {
            array.append(UInt8(intNumber & 0xff))
            intNumber >>= 8
        }
        
        return array.reversed()
    }
    
    func sha256() -> [UInt8]? {
        let arr = self.toUInt8Array()
        
        return arr.digest(.sha256)
    }
}


