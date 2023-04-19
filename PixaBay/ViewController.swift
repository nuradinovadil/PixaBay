//
//  ViewController.swift
//  PixaBay
//
//  Created by Nuradinov Adil on 17/02/23.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher
import AVKit

class ViewController: UIViewController {

    private var imageModelList : [ImageModel] = []
    private var videoUrlList : [String] = []
    private var mediaType: MediaType = .image
    private var pageNumber: Int = 1
    
    private lazy var contentView = UIView()
    
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [MediaType.image.rawValue, MediaType.video.rawValue])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var mediaCollectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Values.mediaCollectionViewCell)
        collectionview.backgroundColor = .clear
        return collectionview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        APICaller.shared.delegate = self
        APICaller.shared.fetchRequest()
        APICaller.shared.fetchRequest(mediaType: .video)
        
        configureNavBar()
        setupViews()
        setupConstraints()
        
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        searchBar.delegate = self
    }

}

extension ViewController: APICallerDelegate {
    func didUpdateVideoModelList(with modelList: [String]) {
        videoUrlList.append(contentsOf: modelList)
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    func didUpdateImageModelList(with modelList: [ImageModel]) {
        imageModelList.append(contentsOf: modelList)
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Following error appeared: ", error)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mediaType {
        case .image: return imageModelList.count
        case .video: return videoUrlList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Values.mediaCollectionViewCell, for: indexPath) as! MediaCollectionViewCell
        switch mediaType {
        case .image:
            cell.contentView.backgroundColor = Constants.Colors.imageColor
            cell.configure(with: imageModelList[indexPath.item])
        case .video:
            cell.contentView.backgroundColor = Constants.Colors.videoColor
            cell.configure()
        }
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height * 0.24
        let width = view.frame.size.width * 0.461
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        if offsetY > height - scrollView.frame.size.height {
            pageNumber += 1
            APICaller.shared.fetchRequest(with: searchBar.text ?? "", mediaType: mediaType, pageNumber: pageNumber)
        }
    }
}

private extension ViewController {
    func configureNavBar() {
        navigationItem.title = "Images and Movies"
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: mediaType = .image
            pageNumber = 1
            videoUrlList.removeAll()
        case 1: mediaType = .video
            pageNumber = 1
            imageModelList.removeAll()
        default: return
        }
        APICaller.shared.fetchRequest(mediaType: mediaType)
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mediaCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        imageModelList.removeAll()
        APICaller.shared.fetchRequest(with: query ?? "")
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mediaType {
        case .image:
            let controller = DetailsViewController()
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            controller.configure(with: imageModelList[indexPath.item].largeImageURL)
            present(controller, animated: true)
        case .video:
            guard let url = URL(string: videoUrlList[indexPath.item]) else { return }
            let player = AVPlayer(url: url)
            let controller = AVPlayerViewController()
            controller.player = player
            controller.allowsPictureInPicturePlayback = true
            self.present(controller, animated: true) {
                controller.player?.play()
            }
        }
        
    }
}

private extension ViewController {
    
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(mediaCollectionView)
        
    }
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        segmentedControl.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.03)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.04)
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

