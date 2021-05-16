//
//  UserDTO.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/04.
//

import Foundation

struct UserDTO: Codable {
    private let name: String?
    private let email: String
    private let userId: String
    let token: String
}
