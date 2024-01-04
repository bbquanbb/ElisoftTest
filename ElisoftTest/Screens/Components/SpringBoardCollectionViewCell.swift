//
//  SpringBoardCollectionViewCell.swift
//  ElisoftTest
//
//  Created by Quan on 28/12/2023.
//

import UIKit
import SDWebImage

class SpringBoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    let indicator = SDWebImageActivityIndicator.gray
    var imgPath: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 7
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
    }
    
    func configCell(imgPath: String) {
        self.imgPath = imgPath
        loadImage()
    }
    
    private func loadImage() {
        imageView.sd_cancelCurrentImageLoad()
        imageView.sd_setImage(with: URL(string: imgPath), placeholderImage: nil)
    }
}
