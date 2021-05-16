//
//  OffenceTeam.swift
//  baseball
//
//  Created by Issac on 2021/05/11.
//

import Foundation

struct OffenceTeam: Codable, Hashable {
    var teamName: String
    var score: Int
    var hitter: Hitter
}
