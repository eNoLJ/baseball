//
//  GameHeaderView.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/06.
//

import UIKit

protocol HeaderScoreReloadable: class {
    func didLoadScoreInfo() -> (offenceTeam: Int, deffenceTeam: Int)
    func didLoadTeamInfo() -> (offenceTeam: String, deffenceTeam: String)
}

final class GameHeaderView: UIView {
    @IBOutlet private weak var defenseTeam: UILabel!
    @IBOutlet private weak var defenseScore: UILabel!
    @IBOutlet private weak var offenceTeam: UILabel!
    @IBOutlet private weak var offenceScore: UILabel!
    
    weak var delegate: HeaderScoreReloadable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetUp()
    }
    
    
    private func xibSetUp() {
        guard let view = loadViewFromNib(nib: "GameHeaderView") else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func teamConfigure(gameInfo: Game? = nil) {
        var teamInfo: (offenceTeam: String, deffenceTeam: String)?
        if let gameInfo = gameInfo {
            teamInfo = gameInfo.loadTeamInfo()
        } else {
            teamInfo = delegate?.didLoadTeamInfo()
        }
        defenseTeam.text = teamInfo?.deffenceTeam
        offenceTeam.text = teamInfo?.offenceTeam

    }
    
    func scoreConfigure(gameInfo: Game? = nil) {
        var scoreInfo: (offenceTeam: Int, deffenceTeam: Int)?
        if let gameInfo = gameInfo {
            scoreInfo = gameInfo.loadScoreInfo()
        } else {
            scoreInfo = delegate?.didLoadScoreInfo()
        }
        defenseScore.text = "\(scoreInfo?.deffenceTeam ?? 0)"
        offenceScore.text = "\(scoreInfo?.offenceTeam ?? 0)"
    }
}
