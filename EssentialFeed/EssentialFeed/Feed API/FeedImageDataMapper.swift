//
//  FeedImageDataMapper.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 27/08/23.
//

import Foundation

public final class FeedImageDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.statusCode == 200, !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}
