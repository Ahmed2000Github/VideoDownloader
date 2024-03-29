//
//  Interactor.swift
//  VideoDownloader
//
//  Created by mac on 3/6/2023.
//

import Foundation


class Interactor{
    func checkContentType(url:URL) async throws->String?{
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type")
            return contentType
        } else {
            return nil
        }
    }
    
    func analyseHtmlPage(url:URL)async throws->[String]{
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        if let htmlString = String(data: data, encoding: .utf8) {
            let parts = url.absoluteString.split(separator: "/")
            let videoTags = extractVideoTag(from: htmlString)
            return extractSrcLinks(from: videoTags,baseUrl: "\(parts[0])//\(parts[1])/")
        }
        return []
    }
    func extractSrcLinks(from html: String,baseUrl:String) -> [String] {
        let pattern = #"src\s*=\s*["']([^"']+)["']"# // Regular expression pattern
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        guard let matches = regex?.matches(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count)) else {
            return []
        }
        
        var srcLinks = [String]()
        for match in matches {
            if let range = Range(match.range(at: 1), in: html) {
                var src = String(html[range])
                if !src.contains("http"){
                    src = baseUrl+src
                }
                srcLinks.append(src)
            }
        }
        
        return srcLinks
    }
    func extractVideoTag(from html:String, tag : String = "video")->String{
        var allTags = ""
        let pattern = "<\(tag)[^>]*>([\\s\\S]*?)<\\/\(tag)>"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let matches = regex.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
            for match in matches {
                let matchRange = match.range
                if let range = Range(matchRange, in: html) {
                    let matchedString = html[range]
                    allTags += "\n" + matchedString
                }
            }
        }
        return allTags
    }
    func getLength(url:URL) async throws ->String?{
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200{
                return nil
            }
            let length = httpResponse.value(forHTTPHeaderField: "Content-Length")
            return length
        } else {
            return nil
        }
    }
    
    func fetchYoutubeVideoMetaData(videoID:String)async -> YoutubeVideoRS?{
        do{
            let url = URL(string: "https://www.youtube.com/youtubei/v1/player")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = """
             {
             "videoId": "\(videoID)",
             "context": {
                 "client": {
                     "clientName": "ANDROID_TESTSUITE",
                     "clientVersion": "1.9",
                     "androidSdkVersion": 30,
                     "hl": "en",
                     "gl": "US",
                     "utcOffsetMinutes": 0
                    }
                 }
             }
             """.data(using: .utf8)
            let (data, _) = try await URLSession.shared.data(for: request)
//            print(String(data: data, encoding: .utf8))
            let model = try JSONDecoder().decode(YoutubeVideoRS.self, from: data)
            return model
        }catch let error {
            print(error)
        }
        
        return nil
    }
    
}
