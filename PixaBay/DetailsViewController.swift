//
//  DetailsViewController.swift
//  PixaBay
//
//  Created by Nuradinov Adil on 03/03/23.
//

import UIKit

final class DetailsViewController: UIViewController {

    private lazy var label = UILabel()
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var exitButton: UIButton = {
       let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(buttonIsTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.81)
        setupViews()
        setupConstraints()
    }

    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            self.imageView.kf.setImage(with: url)
        }
    }
    @objc func buttonIsTapped() {
        dismiss(animated: true)
    }
}

private extension DetailsViewController {
    
    func setupViews() {
        view.addSubview(imageView)
        view.addSubview(exitButton)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(view.frame.size.width)
        }
        exitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(50)
        }
    }
}
