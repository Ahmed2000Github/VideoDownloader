//
//  VideoViewController.swift
//  VideoDownloader
//
//  Created by mac on 4/6/2023.
//

import UIKit

class VideoViewController: UIViewController {
    @IBOutlet weak var loadingProgress: DownloadProgressBar!
    
    @IBOutlet weak var leftDownloadSlideConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightDownloadSlideConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var leftCancelSlideConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCancelSlideConstraint: NSLayoutConstraint!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftCancelSlideConstraint.constant = 500
        self.rightCancelSlideConstraint.constant = -500
        let fileDownloader = FileDownloader()
        fileDownloader.delegate = self
        let fileURL = URL(string: "https://developer.apple.com/documentation/foundation/url_loading_system/analyzing_http_traffic_with_instruments")!
        fileDownloader.downloadFile(from: fileURL)
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+2){
//            self.loadingProgress.updateProgress(percent: 0.5)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now()+13){
//            self.loadingProgress.updateProgress(percent: 0.7)
//        }
    }
    @IBAction func downloadAction(_ sender: Any) {
        
        UIView.animate(withDuration: 2){
            self.leftDownloadSlideConstraint.constant = -500
            self.rightDownloadSlideConstraint.constant = 500
            self.leftCancelSlideConstraint.constant = 10
            self.rightCancelSlideConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        UIView.animate(withDuration: 2){
            self.leftDownloadSlideConstraint.constant = 10
            self.rightDownloadSlideConstraint.constant = 10
            self.leftCancelSlideConstraint.constant = 500
            self.rightCancelSlideConstraint.constant = -500
            self.view.layoutIfNeeded()
        }
    }

    
    
}

extension VideoViewController: DownloadProgressDelegate{
    func updateProgress(progress: Float) {
        DispatchQueue.main.async {[self] in
//            progressView.setProgress(progress/100, animated: true)
            loadingProgress.updateProgress(percent: progress/100)
//            downloadProgressLabel.text = String(format: "%.0f", progress)+"%"
        }
        
    }
    
    func downloadFinishedWithSuccess() {
        DispatchQueue.main.async {[self] in
           
        }
    }
    
    func downloadFinishedWithFailure() {
        DispatchQueue.main.async {[self] in
           
        }
    }
    
    
}

class FileDownloader: NSObject, URLSessionDownloadDelegate {
    var downloadTask: URLSessionDownloadTask?
    var delegate : DownloadProgressDelegate?
    
    func downloadFile(from url: URL) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
        downloadTask?.suspend()
//                DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                    self.downloadTask?.resume()
//                }
    }
    
    // URLSessionDownloadDelegate methods
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // File download finished
        // Handle the downloaded file
        print(location)
        delegate?.downloadFinishedWithSuccess()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // Calculate the download progress
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
            // Handle the download error
            print("Download error: \(error.localizedDescription)")
            delegate?.downloadFinishedWithFailure()
        }
    }
}


protocol DownloadProgressDelegate{
    func updateProgress(progress: Float)
    func downloadFinishedWithSuccess()
    func downloadFinishedWithFailure()
}
