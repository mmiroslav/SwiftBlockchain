//
//  Transaction.swift
//  BlockchainNode
//
//  Created by miroslav on 2/13/18.
//


struct Transaction {
    let sender: BCAddress
    let recipient: BCAddress
    let amount: UInt
    
    var toDictionary: [String: Any] {
        return [
            "sender": self.sender.address,
            "recipient": self.recipient.address,
            "amount": self.amount
        ]
    }
}
