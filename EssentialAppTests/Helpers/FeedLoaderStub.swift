//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Khushnidjon on 25/05/23.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: LoadFeedResult
    
    init(result: LoadFeedResult) {
        self.result = result
    }
    
    func load(completion: @escaping (LoadFeedResult) -> Void) {
        completion(result)
    }
}
