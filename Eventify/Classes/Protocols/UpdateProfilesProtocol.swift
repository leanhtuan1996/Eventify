//
//  UpdateProfilesProtocol.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/28/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation

protocol UpdateProfilesDelegate {
    func updatePassword(with currentPassword: String, andNewPassword newPassword: String, _ completion: @escaping (_ error: String?) -> Void) -> Void
    func updateFullName(with fullname: String, _ completion: @escaping (_ error: String?) -> Void) -> Void
    func updatePhoneNumber(with phoneNumber: String, _ completion: @escaping (_ error: String?) -> Void) -> Void
    func updateEmail(with currentPassword: String, and newEmail: String, _ completion: @escaping (_ error: String?) -> Void) -> Void
    func updatePhoto(with imgData: Data) -> Void
}
