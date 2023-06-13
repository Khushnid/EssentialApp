//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 12/06/23.
//

import XCTest
import EssentialFeed

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    
    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 150, 300, 500].enumerated()
        
        samples.forEach { (index, code) in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json,  at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn2xxHTTPResponseInvalidJSON() {
        let (sut, client) = makeSUT()
        let samples = [200, 201, 204, 288].enumerated()
        
        samples.forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let invalidJSON = Data("Invalid JSON".utf8)
                client.complete(withStatusCode: code, data: invalidJSON, at: index)
            }
        }
    }
    
    func test_load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        let samples = [200, 201, 204, 299].enumerated()
        
        samples.forEach { index, code in
            expect(sut, toCompleteWith: .success([])) {
                let emptyListJSON = makeItemJSON([])
                client.complete(withStatusCode: code, data: emptyListJSON, at: index)
            }
        }
    }
    
    func test_load_deliversItemsOn2xxHTTPResponseWithJSONListItems() {
        let (sut, client) = makeSUT()
        let samples = [200, 201, 204, 299].enumerated()
        
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username"
        )
        
        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
            username: "another username"
        )
        
        let items = [item1.model, item2.model]
        
        samples.forEach { index, code in
            expect(sut, toCompleteWith: .success(items)) {
                let json = makeItemJSON([item1.json, item2.json])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: RemoteImageCommentsFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsFeedLoader(url: url, client: client)
        trackForMemoryLeaks(for: sut, client)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteImageCommentsFeedLoader.Error) -> RemoteImageCommentsFeedLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: UUID, message: String, createdAt: (date: Date, ISO8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        
        let json: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.ISO8601String,
            "author": [
                "username": username
            ]
        ]
        
        return (item, json)
    }
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteImageCommentsFeedLoader,
                        toCompleteWith expectedResult: RemoteImageCommentsFeedLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { recievedResult in
            switch (recievedResult, expectedResult) {
            case let (.success(recievedItems), .success(expectedItems)):
                XCTAssertEqual(recievedItems, expectedItems, file: file, line: line)
                
            case let (.failure(recievedError as RemoteImageCommentsFeedLoader.Error), .failure(expectedError as RemoteImageCommentsFeedLoader.Error)):
                XCTAssertEqual(recievedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(recievedResult) instead", file: file, line: line)
            }
        }
        
        exp.fulfill()
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
