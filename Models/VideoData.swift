//
//  VideoData.swift
//  PixaBay
//
//  Created by Nuradinov Adil on 19/02/23.
//

import Foundation

struct VideoData: Decodable {
    let hits: [VideoHit]
    
    struct VideoHit: Decodable {
        let videos: Video
        
        struct Video: Decodable {
            var medium: Medium
            
            struct Medium: Decodable{
                let url: String
            }
        }
        
    }
}

