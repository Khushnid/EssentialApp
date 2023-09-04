//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 04/09/23.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        
        assertLocalizedKeyAndValueExistInBundle(in: bundle, table)
    }
}
