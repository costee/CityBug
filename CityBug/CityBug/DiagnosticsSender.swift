//
//  DiagnosticsSender.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 24..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import Foundation

/** DiagnosticsSender Class

*/
class DiagnosticsSender {

    static let sharedInstance = DiagnosticsSender()
    
    func sendDiagnostics() {
        print("Diagnostics sent to Citybug")
    }

    private init(){}
}
