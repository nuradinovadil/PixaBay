//
//  Constants.swift
//  PixaBay
//
//  Created by Nuradinov Adil on 17/02/23.
//

import Foundation
import UIKit


struct Constants {
    
    struct API {
        static let key = "33766331-a7478040a0058e1020b59f141"
    }
    
    struct Links {
        static let baseImageURL = "https://pixabay.com/api/"
        static let baseVideoURL = "https://pixabay.com/api/videos/"
        
    }
    
    struct Values {
        static let mediaCollectionViewCell = "MediaCollectionViewCell"
    }
    
    struct Colors{
        static let imageColor = UIColor(red: 237/255, green: 248/255, blue: 235/255, alpha: 1)
        static let videoColor = UIColor(red: 30/255, green: 107/255, blue: 223/255, alpha: 0.2)
    }
}

enum MediaType: String {
    case image = "Image"
    case video = "Video"
}
