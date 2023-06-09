//
//  Presenter.swift
//  VideoDownloader
//
//  Created by mac on 3/6/2023.
//

import Foundation
import UIKit
import AVFoundation

class Presenter{
    
    let interactor = Interactor()
    typealias FileInfoReturnType = (lenght:String,image:UIImage)
   
    func fetchFoundVideo(params: SearchFormViewModel)async throws->[VideoFoundResponse]{
//        let urlString = "https://cdnl.iconscout.com/lottie/premium/thumb/loading-speed-7498520-6102937.mp4"
//        let urlString = "https://chat.openai.com/"
//        let urlString = "https://iconscout.com/all-assets/video-download"
//        let urlString = "https://4yt.articlesknight.com/Anime4upWatchE2.php"
//        let urlString = "https://www.youtube.com/watch?v=-h6OhqtElVs"
//        let urlString = "https://iconscout.com/all-assets/dd"
        let urlString  = params.url
        let url = URL(string: urlString)!
        var videos = [VideoFoundResponse]()
        let contentType = try await interactor.checkContentType(url: url)
        if let contentType{
            switch contentType{
            case "video/mp4" :
                videos.append(VideoFoundResponse(url: urlString))
            default:
                if let _ = extractVideoID(from: urlString){
                    videos.append(VideoFoundResponse(url: urlString,isYoutubeVideo: true))
                }else{
                    let urlList = try await interactor.analyseHtmlPage(url: url)
                    for link in urlList{
                        let url = URL(string: link)!
                        let _contentType = try await interactor.checkContentType(url: url)
                        if let _contentType,
                           _contentType == "video/mp4"{
                            videos.append(VideoFoundResponse(url: link))
                        }
                    }
                }
                
            }
        }
//        try await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        return videos
    }
    
    func getFileInformation(urlString: String,withImage:Bool = true)async->FileInfoReturnType{
        var fileLength = "? Mo"
        var fileImage = UIImage(named: "not-allow-photo")!
        guard let url = URL(string: urlString) else{
            return (fileLength, fileImage)
        }
        do{
            let length = try await interactor.getLength(url: url)
            if let length {
                fileLength =  "\(String(format: "%.1f", (Double(length) ?? 0) / (1024*1024))) Mo"
            }
            if withImage, let image = try await retrieveFirstImageAsync(fromVideo: url){
                    fileImage = image
                
            }
        }catch{}
       
        
        return (fileLength, fileImage)
    }
    func retrieveFirstImageAsync(fromVideo videoURL: URL) async throws -> UIImage? {
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let time = CMTimeMake(value: 1, timescale: 1) // Extract image at 1 second

        let cgImage = try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<CGImage?, Error>) in
            generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { requestedTime, image, _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let image = image {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: NSError(domain: "Image Extraction Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to extract image from video"]))
                }
            }
        }

        if let cgImage {
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } else {
            return nil
        }
    }
    func extractVideoID(from url: String) -> String? {
        let pattern1 = "https://www.youtube.com/watch?v="
        let pattern2 = "https://www.youtube.com/embed/"
        let pattern3 = "https://www.youtube.com/shorts/"
        if url.contains(pattern1){
            let sequence = url.suffix(url.count-pattern1.count)
            return String(sequence)
        }else if url.contains(pattern2){
            let sequence = url.suffix(url.count-pattern2.count)
            return String(sequence)
        }else if url.contains(pattern3){
            let sequence = url.suffix(url.count-pattern3.count)
            return String(sequence)
        }else{
          return nil
        }
    }
    func getYoutubeVideoInformation(link urlString: String)async ->VideoYoutubeInformation?{
        guard let id = extractVideoID(from: urlString) else {
            return nil
        }
        let data = await interactor.fetchYoutubeVideoMetaData(videoID: id)
        guard let data else{
            return nil
        }
        let listFormats = data.streamingData.formats.reduce(into: [FormatInformation]()){parial,element in
            parial.append(FormatInformation(itag: element.itag, url: element.url, mimeType: element.mimeType, bitrate: element.bitrate, width: element.width, height: element.height, lastModified: element.lastModified, contentLength: element.contentLength, quality: element.quality, fps: element.fps, qualityLabel: element.qualityLabel, averageBitrate: element.averageBitrate, approxDurationMS: element.approxDurationMS, highReplication: element.highReplication, audioQuality: element.audioQuality, audioSampleRate: element.audioSampleRate, audioChannels: element.audioChannels))
        }
        let thumbnails = data.videoDetails.thumbnail.thumbnails.reduce(into: [VideoDetailsThumbnailVM]()){
            partial,element in
            partial.append(VideoDetailsThumbnailVM(url: element.url, width: element.width, height: element.height))
            
        }
        let details = VideoDetailsVM(videoID: data.videoDetails.videoID, title:  data.videoDetails.title, lengthSeconds:  data.videoDetails.lengthSeconds, channelID:  data.videoDetails.channelID, isOwnerViewing:  data.videoDetails.isOwnerViewing, shortDescription:  data.videoDetails.shortDescription, isCrawlable:  data.videoDetails.isCrawlable, thumbnails: thumbnails , allowRatings:  data.videoDetails.allowRatings, viewCount:  data.videoDetails.viewCount, author:  data.videoDetails.author, isPrivate:  data.videoDetails.isPrivate, isUnpluggedCorpus:  data.videoDetails.isUnpluggedCorpus, isLiveContent:  data.videoDetails.isLiveContent)
        let videoInfo = VideoYoutubeInformation(formats: listFormats,details: details)
        return videoInfo
    }
    
}
