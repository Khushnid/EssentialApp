//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 12/06/23.
//

import Foundation

final class ImageCommentsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentsFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}

