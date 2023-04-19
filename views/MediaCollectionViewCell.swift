//
//  MediaCollectionViewCell.swift
//  PixaBay
//
//  Created by Nuradinov Adil on 17/02/23.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ImageModel) {
        guard let url = URL(string: model.previewURL) else { return }
        DispatchQueue.main.async {
            self.myImageView.kf.setImage(with: url)
            self.myImageView.contentMode = .scaleToFill
        }
    }
    
    func configure() {
            DispatchQueue.main.async {
                self.myImageView.image = UIImage(systemName: "play.circle.fill")
                self.myImageView.contentMode = .scaleAspectFit
            }
        }
}

private extension MediaCollectionViewCell {
    func setupViews() {
        contentView.addSubview(myImageView)
        contentView.addSubview(imageLabel)
    }
    func setupConstraints() {
        myImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView).multipliedBy(0.75)
        }
        
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(myImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
