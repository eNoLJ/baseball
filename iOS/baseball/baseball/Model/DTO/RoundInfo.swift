//
//  RoundInfo.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import Foundation

struct RoundInfo: Codable, Hashable {
    let round: Int
    let strike: Int
    let ball: Int
    let out: Int
    let firstBase: Bool
    let secondBase: Bool
    let thirdBase: Bool
}
