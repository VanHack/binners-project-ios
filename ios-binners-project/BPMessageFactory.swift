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
    case alert, error, info, text
}


//This could be improved later. Maybe this the turned into a real factory.
class BPMessageFactory {
    

    static func makeMessage(_ type:BPMessageType, message:String) -> UIAlertView {
        
        let alert = UIAlertView()
        alert.message = message
        
        switch type {
            
        case BPMessageType.alert:
            alert.title = "Alert"
            alert.addButton(withTitle: "OK")
        case BPMessageType.error:
            alert.title = "Error"
            alert.addButton(withTitle: "OK")
        case BPMessageType.info:
            alert.title = "Information"
            alert.addButton(withTitle: "OK")
        case .text:
            alert.alertViewStyle = UIAlertViewStyle.plainTextInput
            alert.addButton(withTitle: "Done")
            alert.addButton(withTitle: "Cancel")
        }
        
        return alert
    }


}


