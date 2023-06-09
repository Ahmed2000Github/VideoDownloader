//
//  YoutubeVideoRQ.swift
//  VideoDownloader
//
//  Created by mac on 7/6/2023.
//

import Foundation

struct YoutubeVideoRQ: Codable {
    let videoID: String
    let context: Context

    enum CodingKeys: String, CodingKey {
        case videoID
        case context
    }
}

// MARK: - Context
struct Context: Codable {
    let client: Client
}

// MARK: - Client
struct Client: Codable {
    let clientName, clientVersion: String
    let androidSDKVersion: Int
    let hl, gl: String
    let utcOffsetMinutes: Int

    enum CodingKeys: String, CodingKey {
        case clientName, clientVersion
        case androidSDKVersion
        case hl, gl, utcOffsetMinutes
    }
}
