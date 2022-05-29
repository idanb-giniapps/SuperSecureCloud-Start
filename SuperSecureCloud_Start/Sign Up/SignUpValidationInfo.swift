//
//  SignUpValidationInfo.swift
//  SuperSecureCloud_Start
//
//  Created by Idan Birman on 29/05/2022.
//

import Foundation

struct SignUpValidationInfo: Codable {
	let existingUsernames: [String]
	let existingPasswords: [String]
	let insecurePasswords: [String]
}


extension SignUpValidationInfo {
	static var `default`: SignUpValidationInfo {
		SignUpValidationInfo(existingUsernames: [], existingPasswords: [], insecurePasswords: ["12345678"])
	}
}
