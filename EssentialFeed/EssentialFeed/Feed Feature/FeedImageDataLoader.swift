//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 16/03/23.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
