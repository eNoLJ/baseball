//
//  HeaderScoreReloadable.swift
//  baseball
//
//  Created by Issac on 2021/05/13.
//

import UIKit

class HeaderScoreDelegate: NSObject, HeaderScoreReloadable {
    private var gameManager: GameManager
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
    }
    
    func didLoadScoreInfo() -> (offenceTeam: Int, deffenceTeam: Int) {
        return self.gameManager.gameInfo.loadScoreInfo()
    }
    
    func didLoadTeamInfo() -> (offenceTeam: String, deffenceTeam: String) {
        return self.gameManager.gameInfo.loadTeamInfo()
    }
}
