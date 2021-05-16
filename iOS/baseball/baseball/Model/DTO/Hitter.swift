//
//  Hitter.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import Foundation

struct Hitter: Codable, Hashable {
    let name: String
    let avg: Double
    let tpa: Int
    let hits: Int
}
