//
//  JwtUtil.swift
//  aq-early-warning-ios
//
//  Created by Ryan Barrett on 11/27/21.
//

import SwiftUI

class JwtUtil {
    func isJwtExpired(jwt: String) -> Bool {
        let json = self.parseJwt(jwt: jwt)
        
        let exp = json["exp"] as! Int
        let expDate = Date(timeIntervalSince1970: TimeInterval(exp))
        let isValid = expDate.compare(Date()) == .orderedDescending
        
        return !isValid
    }
    
    func parseJwt(jwt: String) -> [String:Any] {
        var payload64 = jwt.components(separatedBy: ".")[1]
        
        while payload64.count % 4 != 0 {
            payload64 += "="
        }
        
        print("base64 encoded payload: \(payload64)")
        let payloadData = Data(base64Encoded: payload64,
                               options:.ignoreUnknownCharacters)!
        
        let payload = String(data: payloadData, encoding: .utf8)!
        print(payload)
        
        let json = try! JSONSerialization.jsonObject(with: payloadData, options: []) as! [String:Any]
        print("json", json)
        return json
    }
}
