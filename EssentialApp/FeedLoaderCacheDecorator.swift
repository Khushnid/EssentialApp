//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Khushnidjon on 26/05/23.
//

import EssentialFeed

final public class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (LoadFeedResult) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map({ feed in
                self?.cache.save(feed) { _ in }
                return feed
            }))
        }
    }
}
