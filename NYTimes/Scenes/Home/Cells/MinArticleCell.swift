//
//  MinArticleCell.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit
import Kingfisher

class MinArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: Article) {
        mainView.layer.cornerRadius = 12
        imgPoster.layer.cornerRadius = 12
        setImage(urlString: model.getImage(format: .standardThumbnail))
    }
    
    private func setImage(urlString: String?) {
        if let urlString {
            imgPoster.kf.indicatorType = .activity
            imgPoster.kf.setImage(with: urlString.url, placeholder: UIImage(named: "ico-placeholder"))
            imgPoster.contentMode = .scaleAspectFill
        }
    }
}
