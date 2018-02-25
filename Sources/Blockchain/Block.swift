//
//  Block.swift
//  BlockchainNode
//
//  Created by miroslav on 2/13/18.
//
import PerfectLib

class Block {
    let index: Int!
    let timestamp: Double!
    let nonce: UInt
    let previousHash: [UInt8]
    var transactions: [Transaction] = []
    
    init(index: Int, nonce: UInt, previousHash: [UInt8], transactions: [Transaction]) {
        self.index = index
        self.timestamp = getNow()
        self.nonce = nonce
        self.previousHash = previousHash
        self.transactions = transactions
    }

    var toDictionary: [String: Any] {
        return [
            "index": self.index,
            "timestamp": self.timestamp,
            "nonce": self.nonce,
            "previousHash": Utils.hashToString(self.previousHash),
            "transactions": self.arrayOfTransactions()
        ]
    }
    
    func hash() -> [UInt8] {
        let blockStr = blockString()
        guard let hash = blockStr.digest(.sha256) else { return [] }
        return hash
    }
    
    func blockString(_ nonce: UInt? = nil) -> String {
        var nonceToUse = self.nonce
        if nonce != nil { nonceToUse = nonce! }
        
        return "\(index):\(nonceToUse):\(previousHash)"
    }
    
    func validBlock() -> Bool {
        let guess = blockString()
        guard let guessHash = guess.digest(.sha256) else {
            return false
        }
        
        let prefix = guessHash.prefix(Blockchain.complexity)
        return prefix == ArraySlice(repeating: UInt8(0), count: Blockchain.complexity)
    }
    
    func arrayOfTransactions() -> [[String: Any]] {
        var arr: [[String: Any]] = []
        transactions.forEach {
            arr.append($0.toDictionary)
        }
        return arr
    }
}
