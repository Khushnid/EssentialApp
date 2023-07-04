//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 26/04/23.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
