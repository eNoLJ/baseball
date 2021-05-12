//
//  PlayerScoreBoard.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import Foundation

struct PlayerScoreBoard: Codable, Hashable {
    let id: Int
    let name: String
    let tpa: Int
    let hits: Int
    let out: Int
}
