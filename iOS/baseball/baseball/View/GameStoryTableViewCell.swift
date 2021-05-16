//
//  GameStoryTableViewCell.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/05.
//

import UIKit

final class GameStoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(historyInfo: History, index: Int) {
        self.indexLabel.text = "\(index + 1)"
        self.countLabel.text = historyInfo.history
        self.countNumberLabel.text = historyInfo.accumulatedHistory
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
