//
//  Presenter.swift
//  VideoDownloader
//
//  Created by mac on 3/6/2023.
//

import Foundation


class Presenter{
    
    let interactor = Interactor()
   
    func fetchFoundVideo(params: SearchFormViewModel)async throws->[VideoFoundResponse]{
//        let urlString = "https://cdnl.iconscout.com/lottie/premium/thumb/loading-speed-7498520-6102937.mp4"
//        let urlString = "https://chat.openai.com/"
//        let urlString = "https://iconscout.com/all-assets/video-download"
//        let urlString = "https://4yt.articlesknight.com/Anime4upWatchE2.php"
//        let urlString = "https://www.youtube.com/watch?v=-h6OhqtElVs"
        let urlString = "https://iconscout.com/all-assets/dd"
        let url = URL(string: urlString)!
        var videos = [VideoFoundResponse]()
        let contentType = try await interactor.checkContentType(url: url)
//        print("The content type is : ")
//        print(contentType!)
        if let contentType{
            switch contentType{
            case "video/mp4" :
                videos.append(VideoFoundResponse(url: urlString))
// Content-type : text/html
            default:
                let urlList = try await interactor.analyseHtmlPage(url: url)
                print(url)
                for link in urlList{
                    let url = URL(string: link)!
                    let _contentType = try await interactor.checkContentType(url: url)
                    print(_contentType!)
                    if let _contentType,
                       _contentType == "video/mp4"{
                        print("add link")
                        videos.append(VideoFoundResponse(url: link))
                    }
                }
            }
        }
//        try await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        return videos
    }
    
}
