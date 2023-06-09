//
//  VideoFoundResponse.swift
//  VideoDownloader
//
//  Created by mac on 3/6/2023.
//

import Foundation

struct VideoFoundResponse{
    let url: String;
    let isYoutubeVideo:Bool
    
    init(url: String, isYoutubeVideo: Bool = false) {
        self.url = url
        self.isYoutubeVideo = isYoutubeVideo
    }
}
