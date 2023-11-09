//
//  ArticleCell.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit
import Kingfisher

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 12
        imgPoster.layer.cornerRadius = 12
    }
    
    func configure(with model: Article) {
        title.text = model.title
        setPosterImage(urlString: model.getImage(format: .mediumThreeByTwo440))
    }
    
    private func setPosterImage(urlString: String?) {
        if let urlString {
            imgPoster.kf.indicatorType = .activity
            imgPoster.kf.setImage(with: urlString.url, placeholder: UIImage(named: "ico-placeholder"))
            imgPoster.contentMode = .scaleAspectFill
        }
    }
}
