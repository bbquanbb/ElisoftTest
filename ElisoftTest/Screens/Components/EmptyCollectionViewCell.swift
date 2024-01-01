//
//  EmptyCollectionViewCell.swift
//  ElisoftTest
//
//  Created by Quan on 29/12/2023.
//

import Foundation
import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
    // Customize the appearance of your empty cell as needed
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // Add any customization for your empty cell, such as background color
        backgroundColor = .clear
    }
}
