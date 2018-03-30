//
//  ImageFilterCell.swift
//  CropFilter
//
//  Created by Alex Paul on 3/29/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class ImageFilterCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //imageView.image = UIImage.init(named: "placeholder-image")
        return imageView
    }()
    
    lazy var filterNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        //label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ImageFilterCell {
    private func setupViews() {
        setupFilterNameLabel()
    }
    
    private func setupFilterNameLabel() {
        addSubview(filterNameLabel)
        filterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            filterNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }
    
    public func configureCell(filterName: String) {
    }
}
