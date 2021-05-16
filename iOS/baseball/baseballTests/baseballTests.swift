//
//  baseballTests.swift
//  baseballTests
//
//  Created by 양준혁 on 2021/05/03.
//

import XCTest
import Combine
@testable import baseball

class baseballTests: XCTestCase {
    var sut: ServerCommunicable!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkingCenter()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testGameListNetwork() {
        var cancelBag = Set<AnyCancellable>()
        let promise = expectation(description: "Completion handler call")
        
        guard let url = Endpoint.url(path: .gameList) else { return }
        
        let publisher: AnyPublisher<[PairTeams], Error> = sut.request(url: url, path: .gameList, token: nil)
        publisher.sink { (completion) in
            switch completion {
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            case .finished:
                promise.fulfill()
            }
        } receiveValue: { (pairTeams) in
        }.store(in: &cancelBag)
        
        wait(for: [promise], timeout: 3)
    }
}
