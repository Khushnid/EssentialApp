//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 14/04/23.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    weak var controller: FeedViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakReferenceVirtialProxy<FeedImageCellController>>
    
    init(controller: FeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.url)
            })
            
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakReferenceVirtialProxy(view),
                loadingView: WeakReferenceVirtialProxy(view),
                errorView: WeakReferenceVirtialProxy(view),
                mapper: UIImage.tryMake
            )
            
            return view
        })
    }
}

private extension UIImage {
    struct InvalidImageData: Error {}
    
    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }
        return image
    }
}
