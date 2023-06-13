//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 07/02/23.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
