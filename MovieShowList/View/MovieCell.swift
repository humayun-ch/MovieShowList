//
//  MovieCell.swift
//  MovieShowList
//
//  Created by Macbook Pro on 6/3/23.
//

import UIKit

class MovieCell: UITableViewCell {
    //MARK: - Properties
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        addSubview(posterImageView)
        posterImageView.anchor(left: leftAnchor, centerY: centerYAnchor, paddingLeft: 20, width: 70, height: 140)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: posterImageView.rightAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
        addSubview(descLabel)
        descLabel.anchor(top: titleLabel.bottomAnchor, left: posterImageView.rightAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
}
