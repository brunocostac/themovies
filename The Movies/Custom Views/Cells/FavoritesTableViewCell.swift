//
//  FavoritesTableViewCell.swift
//  The Movies
//
//  Created by Bruno Costa on 01/02/23.
//

import UIKit
import SDWebImage

class FavoritesTableViewCell: UITableViewCell {
    
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    let releaseDateLabel = UILabel()
    
    let maxOverviewCharacterCount = 110
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12)
        releaseDateLabel.textColor = .lightGray
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(releaseDateLabel)
        
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            releaseDateLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            releaseDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(title: String, overview: String, release: String, imageURL: URL) {
        self.titleLabel.text = title
        self.releaseDateLabel.text = release
        
        if overview.count > maxOverviewCharacterCount {
                let index = overview.index(overview.startIndex, offsetBy: maxOverviewCharacterCount)
                let truncatedOverview = overview[..<index] + "..."
                overviewLabel.text = String(truncatedOverview)
            } else {
                overviewLabel.text = overview
        }
        self.posterImageView.sd_setImage(with: imageURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder)")
    }
}
