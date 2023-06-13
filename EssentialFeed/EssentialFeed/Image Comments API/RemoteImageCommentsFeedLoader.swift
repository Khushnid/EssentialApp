//
//  RemoteImageCommentsFeedLoader.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 12/06/23.
//

import Foundation

public typealias RemoteImageCommentsFeedLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
