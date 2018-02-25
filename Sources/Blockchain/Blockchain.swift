//
//  Blockchain.swift
//  BlockchainNode
//
//  Created by miroslav on 2/13/18.
//
import PerfectHTTP
import PerfectHTTPServer
import PerfectCrypto
import Foundation

class Blockchain {
    
    var blocks: [Block] = []
    var currentTransactions: [Transaction] = []
    var nodes: [URL] = []
    
    static let shared = Blockchain()
    
    fileprivate init() {
        blocks.append(Utils.genesisBlock())
    }
    
    static var complexity: Int {
        return 2
    }
    
    func newBlock(nonce: UInt, previousHash: [UInt8]? = nil) -> Block? {
        print("new Block")
        guard let last = blocks.last else { return nil }
        // TODO: lock transactions varable somehow
        let block  = Block(
            index: (blocks.count),
            nonce: nonce,
            previousHash: previousHash ?? last.hash(),
            transactions: self.currentTransactions
        )
        
        self.currentTransactions = []
        // TODO: unlock transactions varable
        self.blocks.append(block)
        return block
    }
    
    func validateChain(chain: [Block]) -> Bool {
        guard var lastBlock = chain.first else { return false }
        
        for index in 1...(chain.endIndex) {
            let block = chain[index]
            
            print(lastBlock)
            print(block)
            print("---------------")
            
            if block.previousHash != lastBlock.hash() {
                return false
            }
            
            if !block.validBlock() {
                return false
            }
            
            lastBlock = block
        }
        return true
    }
    
    // MARK: Nonce
    
    static func validNonce(block: Block?, nonce: UInt?) -> Bool {
        guard let block = block else { return false }
        guard let nonce = nonce else { return false }
        
        let guess = block.blockString(nonce)
        guard let guessHash = guess.digest(.sha256) else {
            return false
        }
        
        let prefix = guessHash.prefix(Blockchain.complexity)
        return prefix == ArraySlice(repeating: UInt8(0), count: Blockchain.complexity)
    }
    
    func calculateNonce(block: Block) -> UInt {
        print("calculate nonce ")
        var nonce: UInt = 0
        
        while !Blockchain.validNonce(block: block, nonce: nonce) {
            nonce += 1
            print(nonce)
        }
        return nonce
    }
    
    // MARK: Transactions
    
    func newTransaction(from sender: BCAddress, to recipient: BCAddress, amount: UInt) -> Transaction {
        let transaction = Transaction(sender: sender, recipient: recipient, amount: amount)
        self.currentTransactions.append(transaction)
        return transaction
    }
    

    // MARK: Nodes
    
    func registerNode(node: URL) {
        if !self.nodes.contains(node) {
            self.nodes.append(node)
        }
    }
    
    // MARK: mine new block
    func mineBlock() -> Block? {
        print("mine Block ")
        let tmpBlock = Block(index: blocks.count, nonce: 0, previousHash: blocks.last!.hash(), transactions: self.currentTransactions)
        let nonce = calculateNonce(block: tmpBlock)
        
        return self.newBlock(nonce: nonce, previousHash: blocks.last?.hash())
    }
    
    func arrayOfBlocks() -> [[String: Any]] {
        var arr: [[String: Any]] = []
        blocks.forEach {
            arr.append($0.toDictionary)
        }
        return arr
    }
    
}
