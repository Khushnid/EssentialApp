//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Khushnidjon on 02/06/23.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
