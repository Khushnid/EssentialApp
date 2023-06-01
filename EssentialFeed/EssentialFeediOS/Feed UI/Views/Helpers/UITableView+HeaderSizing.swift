//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 01/06/23.
//

import UIKit

extension UITableView {
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if header.frame.height != size.height {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
