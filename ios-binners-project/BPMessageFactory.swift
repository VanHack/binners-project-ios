//
//  BPMessageFactory.swift
//  ios-binners-project
//
//  Created by Julio Cesar Fausto on 15/02/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

//Types of messages that the user could receive from the app
enum BPMessageType {
    case ALERT, ERROR, INFO
}


//This could be improved later. Maybe this the turned into a real factory.
class BPMessageFactory {
    

    static func makeMessage(type:BPMessageType, message:String) -> UIAlertView {
        
        let alert = UIAlertView()
        alert.message = message
        
        switch type {
            
        case BPMessageType.ALERT:
            alert.title = "Alert"
            alert.addButtonWithTitle("OK")
        case BPMessageType.ERROR:
            alert.title = "Error"
            alert.addButtonWithTitle("OK")
        case BPMessageType.INFO:
            alert.title = "Information"
            alert.addButtonWithTitle("OK")
        }
        
        return alert
    }

}


