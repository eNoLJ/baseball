//
//  GameManager.swift
//  baseball
//
//  Created by Issac on 2021/05/06.
//

import Foundation
import Combine

final class GameManager: ObservableObject {
    private let networkingCenter: ServerCommunicable
    private(set) var token: String!
    @Published private(set) var gameInfo: Game!
    @Published private(set) var teams: [PairTeams]!
    @Published private(set) var scoreBoardInfo: ScoreBoard!
    @Published private(set) var homePlayerScoreBoardInfo: [PlayerScoreBoard]!
    @Published private(set) var awayPlayerScoreBoardInfo: [PlayerScoreBoard]!
    private(set) var history: History!
    private var cancelable = Set<AnyCancellable>()
    var errorHandler: ((String) -> ())?
    
    
    init(serverCommunicable: ServerCommunicable) {
        self.networkingCenter = serverCommunicable
    }
    
    func setToken(token: String) {
        self.token = token
    }
    
    func setGameData(game: Game) {
        self.gameInfo = game
    }
    
    //MARK: - Network
    func getGameInfo(teamName: String?) {
        guard let url = Endpoint.url(path: .gameStart, parameter: teamName ?? "") else { return }
        let publisher: AnyPublisher<Game, Error> = self.networkingCenter.request(url: url, path: .gameStart, token: self.token)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(#function, url)
                self.errorHandler?(error.localizedDescription)
            }
        } receiveValue: { (game) in
            self.gameInfo = game
        }.store(in: &self.cancelable)
    }
    
    func getScoreBoard() {
        guard let url = Endpoint.url(path: .gameScore) else { return }
        let publisher: AnyPublisher<ScoreBoard, Error> = self.networkingCenter.request(url: url, path: .gameScore, token: self.token)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(#function)
                self.errorHandler?(error.localizedDescription)
            }
        } receiveValue: { (scoreBoard) in
            self.scoreBoardInfo = scoreBoard
            self.getPlayerScoreBoard(of: scoreBoard.homeTeam.teamName, isHomeTeam: true)
        }.store(in: &self.cancelable)
    }
    
    func getPlayerScoreBoard(of team: String, isHomeTeam: Bool) {
        guard let url = Endpoint.url(path: .playerScore, parameter: team) else { return }
        let publisher: AnyPublisher<[PlayerScoreBoard], Error> = self.networkingCenter.request(url: url, path: .playerScore, token: self.token)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(#function)
                self.errorHandler?(error.localizedDescription)
            }
        } receiveValue: { (playerScoreBoard) in
            if isHomeTeam {
                self.homePlayerScoreBoardInfo = playerScoreBoard
            } else {
                self.awayPlayerScoreBoardInfo = playerScoreBoard
            }
        }.store(in: &self.cancelable)
    }
    
    func getTeams() {
        guard let url = Endpoint.url(path: .gameList) else { return }
        let publisher: AnyPublisher<[PairTeams], Error> = self.networkingCenter.request(url: url, path: .gameList, token: self.token)
        publisher.sink { (completion) in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(#function)
                self.errorHandler?(error.localizedDescription)
            }
        } receiveValue: { (pairTeams) in
            self.teams = pairTeams
        }.store(in: &self.cancelable)
    }
    
    //MARK: - Business Logic
    enum Team: Int {
        case home = 0
        case away = 1
    }
    
    typealias PlayerScore = (tpa: Int, hits: Int, out: Int)
    
    func makeHistory(gameInfo: Game) -> [History] {
        let numberCountHistory = gameInfo.calcurateHistory()
        var historyBook = [History]()
        guard let story = gameInfo.story, !story.isEmpty else {
            return [History]()
        }
        for (index, eachStory) in story.enumerated() {
            let history = History(history: eachStory, accumulatedHistory: numberCountHistory[index])
            historyBook.append(history)
        }
        return historyBook
    }
    
    func totalPlayerScoreCount(team: Team) -> PlayerScore {
        return (team == .home ? homePlayerScoreBoardInfo : awayPlayerScoreBoardInfo)
            .reduce((tpa: 0, hits: 0, out: 0)) { (result, playerScoreBoard) -> PlayerScore in
                return (result.tpa + playerScoreBoard.tpa,
                        result.hits + playerScoreBoard.hits,
                        result.out + playerScoreBoard.out)
            }
    }
    
    func makeRoundInfo() -> String {
        return "\(gameInfo.roundInfo.round)회\(gameInfo.playTeam == gameInfo.defenseTeam.teamName ? "초 공격" : "말 수비")"
    }
}
