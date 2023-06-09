//
//  VideoYoutubeInformation.swift
//  VideoDownloader
//
//  Created by mac on 7/6/2023.
//

import Foundation


struct  VideoYoutubeInformation{
    let formats : [FormatInformation]
    let details:VideoDetailsVM
}

struct FormatInformation  {
    let itag: Int
    let url: String
    let mimeType: String
    let bitrate: Int
    let width, height: Int?
    let lastModified: String
    let contentLength: String?
    let quality: String
    let fps: Int?
    let qualityLabel: String?
    let averageBitrate: Int?
    let approxDurationMS: String
    let highReplication: Bool?
    let audioQuality, audioSampleRate: String?
    let audioChannels: Int?

}


struct VideoDetailsVM {
    let videoID, title, lengthSeconds, channelID: String
    let isOwnerViewing: Bool
    let shortDescription: String
    let isCrawlable: Bool
    let thumbnails: [VideoDetailsThumbnailVM]
    let allowRatings: Bool
    let viewCount, author: String
    let isPrivate, isUnpluggedCorpus, isLiveContent: Bool
}


struct VideoDetailsThumbnailVM {
    let url: String
    let width, height: Int
}
