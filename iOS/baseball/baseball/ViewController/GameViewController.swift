//
//  GameViewController.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import UIKit
import SnapKit
import Combine
import DCAnimationKit
import SwiftConfettiView

final class GameViewController: UIViewController{
    enum Section {
        case main
    }
    
    @IBOutlet weak var gameHeaderView: GameHeaderView!
    @IBOutlet weak var gameView: GameView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var ballCountTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet private var strikeCount: [UIImageView]!
    @IBOutlet private var ballCount: [UIImageView]!
    @IBOutlet private var outCount: [UIImageView]!
    @IBOutlet weak var picherName: UILabel!
    @IBOutlet weak var picherCount: UILabel!
    @IBOutlet weak var hitterName: UILabel!
    @IBOutlet weak var hitterCount: UILabel!
    
    private lazy var dataSource = makeDataSource()
    private(set) var gameManager: GameManager!
    private var cancelable = Set<AnyCancellable>()
    private typealias Datasource = UITableViewDiffableDataSource<Section, History>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, History>
    private var snapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gameHeaderViewDelegate = HeaderScoreDelegate(gameManager: self.gameManager)
        self.gameHeaderView.delegate = gameHeaderViewDelegate
        registerNib()
        bind()
        appearPitchButton()
        self.makeSnapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func bind() {
        self.gameManager.$gameInfo
            .receive(on: DispatchQueue.main)
            .sink { (game) in
                guard let game = game else { return }
                let history = self.gameManager.makeHistory(gameInfo: game)
                self.gameHeaderView.teamConfigure(gameInfo: game)
                self.gameHeaderView.scoreConfigure(gameInfo: game)
                self.setGameCount()
                self.setRoundInfo()
                self.setPlayers()
                self.gameView.setPlayerLayer(firstBase: game.roundInfo.firstBase, secondBase: game.roundInfo.secondBase, thirdBase: game.roundInfo.thirdBase)
                self.applySnapshot(history: history, animatingDifferences: false)
            }.store(in: &cancelable)
    }
    
    func setRoundInfo() {
        self.roundLabel.text = self.gameManager.makeRoundInfo()
    }
    
    func setGameManager(_ manager: GameManager) {
        self.gameManager = manager
    }
    
    private func registerNib() {
        let nibName = UINib(nibName: "GameStoryTableViewCell", bundle: nil)
        ballCountTableView.register(nibName, forCellReuseIdentifier: GameStoryTableViewCell.className)
    }
    
    private func makeDataSource() -> Datasource {
        Datasource.init(tableView: ballCountTableView) { (tableView, indexPath, history) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GameStoryTableViewCell.className, for: indexPath) as? GameStoryTableViewCell else { return GameStoryTableViewCell() }
            cell.configure(historyInfo: history, index: indexPath.row)
            self.reverseTableView(cell: cell, tableView: tableView)
            return cell
        }
    }
    
    private func reverseTableView(cell: UITableViewCell, tableView: UITableView) {
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
    }
    
    private func applySnapshot(history: [History], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(history, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func appearPitchButton() {
        let pitchButton = PitchButton()
        pitchButton.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        self.view.addSubview(pitchButton)
        pitchButton.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.gameView.safeAreaLayoutGuide)
            $0.width.equalTo(120)
            $0.height.equalTo(30)
        }
    }
    
    @objc func buttonDidTap() {
        gameView.hit()
        homerunAnimation()
    }
    
    func homerunAnimation() {
        self.snapView.isHidden = false
        self.snapView.alpha = 1.0
        snapView.snap(into: self.view, direction: DCAnimationDirection.top)
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1.0) {
                self.snapView.alpha = 0
                confettiView.alpha = 0
            } completion: { (_) in
                self.snapView.isHidden = true
                confettiView.removeFromSuperview()
            }
        }
    }
    
    private func makeSnapView() {
        snapView = UIView(frame: CGRect(x:0, y: 0, width: 280, height: 150))
        snapView.backgroundColor = .systemGray2
        snapView.layer.cornerRadius = 15
        snapView.layer.masksToBounds = false
        snapView.center = self.view.center
        snapView.isHidden = true
        
        let homerunLabel = UILabel()
        homerunLabel.text = "🎉HOME RUN🎉"
        homerunLabel.font = .boldSystemFont(ofSize: 28)
        homerunLabel.textColor = .systemGray5
        homerunLabel.sizeToFit()
        snapView.addSubview(homerunLabel)
        self.view.addSubview(snapView)
        homerunLabel.translatesAutoresizingMaskIntoConstraints = false
        homerunLabel.centerXAnchor.constraint(equalTo: snapView.centerXAnchor).isActive = true
        homerunLabel.centerYAnchor.constraint(equalTo: snapView.centerYAnchor).isActive = true
    }
}

extension GameViewController {
    private func setGameCount() {
        let strike = self.gameManager.gameInfo.roundInfo.strike
        let ball = self.gameManager.gameInfo.roundInfo.ball
        let out = self.gameManager.gameInfo.roundInfo.out
        
        self.strikeCount.enumerated().forEach { (index, strikeImage) in
            strikeImage.image = index + 1 <= strike ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        }
        self.ballCount.enumerated().forEach { (index, ballImage) in
            ballImage.image = index + 1 <= ball ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        }
        self.outCount.enumerated().forEach { (index, outImage) in
            outImage.image = index + 1 <= out ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        }
    }
    
    private func setPlayers() {
        guard let gameInfo = self.gameManager.gameInfo else { return }
        self.picherName.text = gameInfo.defenseTeam.pitcher.name
        self.picherCount.text = "#\(gameInfo.defenseTeam.pitcher.pit)"
        self.hitterName.text = gameInfo.offenceTeam.hitter.name
        self.hitterCount.text = "\(gameInfo.offenceTeam.hitter.tpa)타석 \(gameInfo.offenceTeam.hitter.hits)안타"
    }
    
}
