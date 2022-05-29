//
//  SignUpView.swift
//  SuperSecureCloud
//
//  Created by Idan Birman on 22/05/2022.
//

import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
	private let validator = SignUpValidator()
	private var usernameValidationTask: Task<Void, Never>?
	private var passwordValidationTask: Task<Void, Never>?
	
	@Published var username: String = ""
	@Published var password: String = ""
	
	@Published private(set) var usernameValidationError: ValidationError.Username?
	@Published private(set) var passwordValidationError: ValidationError.Password?
	@Published private(set) var generalError: Error?
		
	/// Start listening to `username` and `password` input changes and and validate them continuously.
	func start() {
		_ = _start
	}
	
	private lazy var _start: Void = {
		startValidatingUsername()
		startValidatingPassword()
	}()
	
	private func startValidatingUsername() {
		usernameValidationTask = Task {
			let usernameValues = $username
				.debounce(for: 0.5, scheduler: RunLoop.main)
				.values
			
			for await usernameValue in usernameValues {
				do {
					try await validator.validate(username: usernameValue)
					await MainActor.run {
						withAnimation { usernameValidationError = nil }
					}
				} catch {
					if let usernameError = error as? ValidationError.Username {
						await MainActor.run {
							withAnimation { usernameValidationError = usernameError }
						}
					}
				}
			}
		}
	}
	
	private func startValidatingPassword() {
		passwordValidationTask = Task {
			let passwordValues = $password
				.debounce(for: 0.5, scheduler: RunLoop.main)
				.values
			
			for await passwordValue in passwordValues {
				do {
					try await validator.validate(password: passwordValue)
					await MainActor.run {
						withAnimation { passwordValidationError = nil }
					}
				} catch {
					if let passwordError = error as? ValidationError.Password {
						await MainActor.run {
							withAnimation { passwordValidationError = passwordError }
						}
					}
				}
			}
		}
	}
}
