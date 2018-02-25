//
//  main.swift
//  BlockchainNode
//
//  Created by miroslav on 2/13/18.
//

import PerfectHTTP
import PerfectHTTPServer


func mine(request: HTTPRequest, response: HTTPResponse) {
    print("mine")
    do {
        guard let block = Blockchain.shared.mineBlock() else {
            throw HTTPResponseError(status: .notFound, description: "Block not found")
        }
        
        try response.setBody(json: [
            "message": "New block forged",
            "index": block.index,
            "transactions": block.transactions,
            "nonce": block.nonce,
            "hash": Utils.hashToString(block.hash())
            ])
            .setHeader(HTTPResponseHeader.Name.contentType, value: "application/json")
            .completed(status: .accepted)
    } catch {
        do {
            try response.setBody(json: [
                "error": "Error handling request",
                "errorDescription": error.localizedDescription])
                .completed(status: .internalServerError)
        } catch {
            print(error.localizedDescription)
        }
    }
}

func chain(request: HTTPRequest, response: HTTPResponse) {
    do {
        try response.setBody(json: [
            "chain": Blockchain.shared.arrayOfBlocks()
            ])
            .setHeader(HTTPResponseHeader.Name.contentType, value: "application/json")
            .completed(status: .accepted)
        
    } catch {
        do {
            try response.setBody(json: [
                "error": "Error handling request",
                "errorDescription": error.localizedDescription])
                .completed(status: .internalServerError)
        } catch {
            print(error.localizedDescription)
        }
    }
}

func newTransaction(request: HTTPRequest, response: HTTPResponse) {
    do {
        guard let sender = request.param(name: "sender") else {
            throw HTTPResponseError(status: .badRequest, description: "Param missing")
        }
        guard let recipient = request.param(name: "recipient") else {
            throw HTTPResponseError(status: .badRequest, description: "Param missing")
        }
        guard let amountString = request.param(name: "amount"), let amount = UInt(amountString)  else {
            throw HTTPResponseError(status: .badRequest, description: "Param missing")
        }
        
        let transaction = Blockchain.shared.newTransaction(from: BCAddress(address: sender),
                                                           to: BCAddress(address: recipient),
                                                           amount: amount)
        
        try response.setBody(json: [
            "transaction": transaction.toDictionary
            ])
            .setHeader(HTTPResponseHeader.Name.contentType, value: "application/json")
            .completed(status: .accepted)
        
    } catch {
        do {
            try response.setBody(json: [
                "error": "Error handling request",
                "errorDescription": error.localizedDescription])
                .completed(status: .internalServerError)
        } catch {
            print(error.localizedDescription)
        }
    }
}

let confData = [
	"servers": [
		[
			"name":"localhost",
			"port":8181,
			"routes":[
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
				 "documentRoot":"./webroot",
				 "allowResponseFilters":true],
                ["method":"get", "uri":"/mine", "handler":mine],
                ["method":"get", "uri":"/blockchain", "handler":chain],
                ["method":"post", "uri":"/transaction/new", "handler":newTransaction]
                
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		]
	]
]

do {
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}

