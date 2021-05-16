//
//  Game.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import Foundation

struct Game: Codable, Hashable {
    let playTeam: String
    let roundInfo: RoundInfo
    let defenseTeam: DefenseTeam
    let offenceTeam: OffenceTeam
    let story: [String]?
    
    func calcurateHistory() -> [String] {
        guard let story = story else { return [String]() }
        var accumulatedHistory = [String]()
        var strike = 0, ball = 0
        for result in story {
            if result == "볼" {
                ball += 1
            } else {
                strike += 1
            }
            accumulatedHistory.append("\(strike)-\(ball)")
        }
        return accumulatedHistory
    }
    
    func loadScoreInfo() -> (offenceTeam: Int, deffenceTeam: Int) {
        return (self.offenceTeam.score, self.defenseTeam.score)
    }
    
    func loadTeamInfo() -> (offenceTeam: String, deffenceTeam: String) {
        return (self.offenceTeam.teamName, self.defenseTeam.teamName)
    }
    
}
