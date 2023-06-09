//
//  FileDownloader.swift
//  VideoDownloader
//
//  Created by mac on 5/6/2023.
//

import Foundation
import AVFoundation




class FileDownloader: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    var downloadTask: URLSessionDownloadTask?
    var delegate : DownloadProgressDelegate?
    var hasResumedData = false
    var isVideoType = true
    var  session: URLSession!
    
    
    
    override init(){
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func downloadFile(from url: URL,resumedData:Data?=nil) {
       
        if let data = resumedData{
            downloadTask = session.downloadTask(withResumeData: data)
        }else{
            downloadTask = session.downloadTask(with: url)
        }
        downloadTask?.resume()
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            do {
                if isVideoType{
                    let destinationURL = getFileURL(fileName: delegate?.completeFileName() ?? "default")
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try FileManager.default.removeItem(at: destinationURL)
                    }
                    try FileManager.default.moveItem(at: location, to: destinationURL)
                    
                    print("File downloaded and saved at: \(destinationURL)")
                }else{
                    Task{
                        let videoData = try Data(contentsOf: location)
                        let audioURL = try await convertVideoToAudio(videoData: videoData,fileName: delegate?.completeFileName() ?? "default" )
                        print("Audio URL: \(audioURL)")
                    }
                }
                hasResumedData = false
                delegate?.downloadFinishedWithSuccess()
            } catch {
                print("Error moving file: \(error)")
            }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        var progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download Mo: \(Double(totalBytesWritten) / (1024 * 1024))")
        print("Download progress: \(Float(progress) * 100)")
        if progress<0 {
            progress = 1.0
        }
        delegate?.updateProgress(progress: Float(progress) * 100)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
        
            print("Download error: \(error.localizedDescription)")
            delegate?.downloadFinishedWithFailure(error: error.localizedDescription)
            if let resumeData = (error as NSError).userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                            let fileURL = getFileURL() 
                            do {
                                try resumeData.write(to: fileURL)
                                hasResumedData = true
                            } catch {
                            }
                        }
                  
               }
               
              
    }
    
    func getFileURL(fileName:String = "default.tmp")->URL{
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectoryURL.appendingPathComponent(fileName)
        return destinationURL
    }

    func convertVideoToAudio(videoData: Data,fileName:String) async throws -> URL {
        print("Processing the video ... ")
        let videoURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tempVideo.mp4")
        try  videoData.write(to: videoURL)
        let asset = AVAsset(url: videoURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            throw NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Export session initialization failed."])
        }
        
        exportSession.outputFileType = .m4a
        exportSession.outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        exportSession.shouldOptimizeForNetworkUse = true
        
        return try await withCheckedThrowingContinuation { continuation in
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    print("Processing completed ... ")
                    continuation.resume(returning: exportSession.outputURL!)
                case .failed, .cancelled, .unknown:
                    continuation.resume(throwing: exportSession.error!)
                default:
                    break
                }
            }
        }
    }

}

