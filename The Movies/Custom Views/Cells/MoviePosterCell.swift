//
//  MoviePosterTableViewCell.swift
//  The Movies
//
//  Created by Bruno Costa on 30/01/23.
//

import UIKit
import SDWebImage


protocol FavoriteDelegate: AnyObject {
    func toggleFavorite(indexPath: IndexPath)
}

class MoviePosterCell: UICollectionViewCell {
    
    var indexPath: IndexPath?
    var delegate: FavoriteDelegate?
    
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteButton: UIButton = {
       let button = UIButton(type: .system)
       button.tintColor = .systemYellow
       button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(indexPath: IndexPath, title: String, imageURL: URL, isFavorite: Bool) {
        self.indexPath = indexPath
        self.titleLabel.text = title
        self.setupPoster(imageURL: imageURL)
        self.favoriteButton.setImage(UIImage(systemName: isFavorite ? "star.fill" : "star"), for: .normal)
        self.favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }
    
    @objc func toggleFavorite() {
        if let indexPath = indexPath {
          self.delegate?.toggleFavorite(indexPath: indexPath)
        }
    }
    
    func setupPoster(imageURL: URL) {
        self.posterImageView.sd_setImage(with: imageURL)
    }

    
    func setupViews() {
        addSubview(posterImageView)
        addSubview(titleBackgroundView)
        addSubview(titleLabel)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leftAnchor.constraint(equalTo: leftAnchor),
            posterImageView.rightAnchor.constraint(equalTo: rightAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: titleBackgroundView.topAnchor),
            
            titleBackgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            titleBackgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            titleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleBackgroundView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.centerYAnchor.constraint(equalTo: titleBackgroundView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: titleBackgroundView.leftAnchor, constant: 4),
            titleLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: 10),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 72),
            favoriteButton.heightAnchor.constraint(equalToConstant: 72),
            favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            
        ])
        
        self.contentView.isUserInteractionEnabled = false
    }
}

