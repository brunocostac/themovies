//
//  TableView+Extensions.swift
//  The Movies
//
//  Created by Bruno Costa on 02/02/23.
//

import UIKit

extension UITableView {
    
    @objc func setEmptyView(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.backgroundColor = .clear
        messageImageView.image = messageImage
        messageImageView.tintColor = .systemYellow
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.text = title
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        
        NSLayoutConstraint.activate([
            messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20),
            messageImageView.widthAnchor.constraint(equalToConstant: 150),
            messageImageView.heightAnchor.constraint(equalToConstant: 150)
        
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
       
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
        
    
        UIView.animate(withDuration: 1, animations: {
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
}
