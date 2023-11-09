//
//  HorizontalArticleCell.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit
import Kingfisher

class HorizontalArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 12
    }
    
    public func configure(with model: Article) {
        title.text = model.abstract
        setImage(urlString: model.getImage(format: .mediumThreeByTwo210))
    }
    
    public func configure(with model: Doc) {
        title.text = model.abstract
        setImage(urlString: model.getImage())
    }
    
    private func setImage(urlString: String?) {
        if let urlString {
            imgPoster.kf.indicatorType = .activity
            imgPoster.kf.setImage(with: urlString.url, placeholder: UIImage(named: "ico-placeholder"))
            imgPoster.contentMode = .scaleAspectFill
        }
    }
}
