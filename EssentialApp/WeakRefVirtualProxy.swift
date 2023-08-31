//
//  WeakReferenceVirtialProxy.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 14/04/23.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class WeakReferenceVirtialProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakReferenceVirtialProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakReferenceVirtialProxy: ResourceView where T: ResourceView, T.ResourceViewModel == UIImage {
     func display(_ model: UIImage) {
         object?.display(model)
     }
 }

extension WeakReferenceVirtialProxy: ResourceErrorView where T: ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}
