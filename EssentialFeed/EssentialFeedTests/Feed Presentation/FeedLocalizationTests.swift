//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Khushnidjon on 07/04/23.
//

import XCTest
import EssentialFeed

final class FeedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        
        assertLocalizedKeyAndValueExistInBundle(in: bundle, table)
    }
}
