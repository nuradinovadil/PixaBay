//
//  ImageData.swift
//  PixaBay
//
//  Created by Nuradinov Adil on 19/02/23.
//

import Foundation

struct ImageData: Decodable {
    let hits: [ImageHit]
    
    struct ImageHit: Decodable {
        let previewURL: String
        let largeImageURL: String
        
    }
}
