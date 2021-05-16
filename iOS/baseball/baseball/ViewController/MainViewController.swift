//
//  MainViewController.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    @IBOutlet var teams: [UIButton]!
    private var gameManager: GameManager!
    private var cancelable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundAnimation()
        self.bind()
        self.gameManager.getTeams()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func receiveManager(gameManager: GameManager) {
        self.gameManager = gameManager
    }
    
    func bind() {
        self.gameManager.$teams
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (teams) in
                guard let teams = teams else { return }
                self?.loadTeamList(pairTeams: teams)
            }.store(in: &self.cancelable)
    }
    
    func loadTeamList(pairTeams: [PairTeams]) {
        for (index, lineup) in pairTeams.enumerated() {
            teams[index * 2].setTitle(lineup.homeTeamName, for: .normal)
            teams[index * 2 + 1].setTitle(lineup.awayTeamName, for: .normal)
        }
        self.addTarget()
    }
    
    func addTarget() {
        for button in self.teams {
            button.addTarget(self, action: #selector(pushGameTabBar(_:)), for: .touchUpInside)
        }
    }
    
    @objc func pushGameTabBar(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: GameTabBarViewController.className) as? GameTabBarViewController else { return }
        vc.setGameManager(self.gameManager)
        self.gameManager.getGameInfo(teamName: sender.currentTitle)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setBackgroundAnimation() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let colors: [CGColor] = [ #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        let changedColors: [CGColor] = [ #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), ]
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.toValue = changedColors
        colorAnimation.duration = 3
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = .infinity
        
        gradientLayer.add(colorAnimation, forKey: "colorChangeAnimation")
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
