//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 12/06/23.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemJSON([])
        let samples = [199, 150, 300, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn2xxHTTPResponseInvalidJSON() throws {
        let invalidJSON = Data("Invalid JSON".utf8)
        let samples = [200, 201, 204, 288]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemJSON([])
        let samples = [200, 201, 204, 299]

        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [])
        }
    }

    func test_map_deliversItemsOn2xxHTTPResponseWithJSONListItems() throws {

        let samples = [200, 201, 204, 299]

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

        let json = makeItemJSON([item1.json, item2.json])

        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [item1.model, item2.model])
        }
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

    private func expect(_ sut: RemoteLoader<String>,
                        toCompleteWith expectedResult: RemoteLoader<String>.Result,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {

        let exp = expectation(description: "Wait for load completion")

        sut.load { recievedResult in
            switch (recievedResult, expectedResult) {
            case let (.success(recievedItems), .success(expectedItems)):
                XCTAssertEqual(recievedItems, expectedItems, file: file, line: line)

            case let (.failure(recievedError as RemoteLoader<String>.Error), .failure(expectedError as RemoteLoader<String>.Error)):
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
