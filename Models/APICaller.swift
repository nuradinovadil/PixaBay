//
//  APICaller.swift
//  PixaBay
//
//  Created by Nuradinov Adil on 19/02/23.
//

import Foundation
import Alamofire

protocol APICallerDelegate {
    func didUpdateImageModelList(with modelList: [ImageModel])
    func didUpdateVideoModelList(with modelList: [String])
    func didFailWithError(_ error: Error)
}

struct APICaller {
    
    static var shared = APICaller()
    
    var delegate : APICallerDelegate?
    
    func fetchRequest(with query: String = "", mediaType: MediaType = .image, pageNumber: Int = 1) {
        switch mediaType {
        case .image:
            let urlString = "\(Constants.Links.baseImageURL)?key=\(Constants.API.key)&q=\(query)&image_type=photo&page=\(pageNumber)"
            AF.request(urlString).response { response in
                switch response.result {
                case .success(let data):
                    if let modelList = parseImageJSON(with: data!) {
                        delegate?.didUpdateImageModelList(with: modelList)
                    }
                case .failure(let error):
                    delegate?.didFailWithError(error)
                }
            }
        case .video:
            let urlString = "\(Constants.Links.baseVideoURL)?key=\(Constants.API.key)&q=\(query)&page=\(pageNumber)"
            AF.request(urlString).response { response in
                switch response.result {
                case .success(let data):
                    if let urlList = parseVideoJSON(with: data!) {
                        delegate?.didUpdateVideoModelList(with: urlList)
                    }
                case .failure(let error):
                    delegate?.didFailWithError(error)
                }
            }
        }
    }
    
    func parseImageJSON(with data: Data) -> [ImageModel]? {
        var modelList: [ImageModel] = []
        do {
            let decodedData = try JSONDecoder().decode(ImageData.self, from: data)
            for imageData in decodedData.hits {
                let imageModel = ImageModel(previewURL: imageData.previewURL, largeImageURL: imageData.largeImageURL)
                modelList.append(imageModel)
            }
        } catch {
            delegate?.didFailWithError(error)
        }
        return modelList
    }

    func parseVideoJSON(with data: Data) -> [String]? {
        var urlList: [String] = []
        do {
            let decodedData = try JSONDecoder().decode(VideoData.self, from: data)
            for videoData in decodedData.hits {
                urlList.append(videoData.videos.medium.url)
            }
        } catch {
            delegate?.didFailWithError(error)
        }
        return urlList
    }
}


