//
//  FeedUIIntegrationTests+LoaderSpy.swift
//  EssentialAppTests
//
//  Created by Khushnidjon on 27/08/23.
//

import Foundation
import EssentialFeed
import EssentialFeediOS
import Combine

extension FeedUIIntegrationTests {
    func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }
    
    class LoaderSpy: FeedImageDataLoader {
        // MARK: - FeedLoader
        private var feedRequests = [PassthroughSubject<[FeedImage], Error>]()
        
        var loadFeedCallCount: Int {
            return feedRequests.count
        }

        func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
            let publisher = PassthroughSubject<[FeedImage], Error>()
            feedRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }

        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            guard let resultValue = feedRequests[safe: index] else { return }
            resultValue.send(feed)
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
         
            guard let resultValue = feedRequests[safe: index] else { return }
            resultValue.send(completion: .failure(error))
        }
        
        // MARK: - FeedImageDataLoader
        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancelCallback: () -> Void
            
            func cancel() {
                cancelCallback()
            }
        }
        
        private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        private(set) var cancelledImageURLs = [URL]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            imageRequests.append((url, completion))
            
            return TaskSpy { [weak self] in
                self?.cancelledImageURLs.append(url)
            }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
}
