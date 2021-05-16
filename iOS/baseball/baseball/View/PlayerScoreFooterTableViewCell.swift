//
//  PlayerScoreFooterTableViewCell.swift
//  baseball
//
//  Created by Issac on 2021/05/06.
//

import UIKit

final class PlayerScoreFooterTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet weak var tpa: UILabel!
    @IBOutlet weak var hits: UILabel!
    @IBOutlet weak var out: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(playerScore: GameManager.PlayerScore) {
        self.tpa.text = "\(playerScore.tpa)"
        self.hits.text = "\(playerScore.hits)"
        self.out.text = "\(playerScore.out)"
    }
    
    
}
