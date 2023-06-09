//
//  Delegates.swift
//  VideoDownloader
//
//  Created by mac on 5/6/2023.
//

import Foundation


protocol DownloadProgressDelegate{
    func updateProgress(progress: Float)
    func downloadFinishedWithSuccess()
    func downloadFinishedWithFailure(error:String)
    func completeFileName()->String
}
