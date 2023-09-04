//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 26/04/23.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
