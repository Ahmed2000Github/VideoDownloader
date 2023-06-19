//
//  VideoViewController.swift
//  VideoDownloader
//
//  Created by mac on 4/6/2023.
//

import UIKit


class VideoViewController: UIViewController {
    
    
    @IBOutlet weak var loadingProgress: DownloadProgressBar!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var downloadSlide: UIView!
    @IBOutlet weak var cancelSlide: UIView!
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var videoTypeLabel: UILabel!
    @IBOutlet weak var videoTypeBar: UIView!
    @IBOutlet weak var videoTypeTap: UIView!
    @IBOutlet weak var audioTypeLabel: UILabel!
    @IBOutlet weak var audioTypeBar: UIView!
    @IBOutlet weak var audioTypeTap: UIView!
    @IBOutlet weak var cancelCardLabel: UILabel!
    @IBOutlet weak var cancelButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoBar: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var qualitySelectorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedQualityLabel: UILabel!
    @IBOutlet weak var qualityTable: UITableView!
    @IBOutlet weak var qualitySelector: UIView!
    
    var urlString: String = ""
    var isVideoType = true
    var avialableFormats = [FormatInformation]()
    var currentFormat = 0
    var isYoutubeVideo = false
    lazy var width = view.bounds.width
    var presenter = Presenter()
    let fileDownloader = FileDownloader()
    var qualitySelectorGesture : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        urlString = ""
        fileDownloader.delegate = self
        qualityTable.delegate = self
        qualityTable.dataSource = self
        qualityTable.rowHeight = 60
        qualityTable.register(UINib(nibName: "QualityFormatCell", bundle: nil), forCellReuseIdentifier: QualityFormatCell.identifier)
        setSlideEffect(uiview: cancelSlide)
        cancelButtonBottomConstraint.constant = -100
        infoLeftConstraint.constant = width
        infoRightConstraint.constant = -width
        let audioGesture = UITapGestureRecognizer(target: self, action: #selector(audioTypeAction))
        audioTypeTap.addGestureRecognizer(audioGesture)
        let videoGesture = UITapGestureRecognizer(target: self, action: #selector(videoTypeAction))
        videoTypeTap.addGestureRecognizer(videoGesture)
        
        qualitySelectorGesture = UITapGestureRecognizer(target: self, action: #selector(qualitySelectAction))
        qualitySelector.addGestureRecognizer(qualitySelectorGesture)

        qualitySelector.layer.cornerRadius = 10
        videoTypeBar.layer.cornerRadius = 2.5
        audioTypeBar.layer.cornerRadius = 2.5
        infoBar.layer.cornerRadius = 10
        previewImage.layer.cornerRadius = 10
        previewImage.clipsToBounds = true
        Task{
            if isYoutubeVideo{
                let videoYUdata = await presenter.getYoutubeVideoInformation(link: urlString)
                avialableFormats = videoYUdata?.formats ?? [FormatInformation]()
                selectedQualityLabel.text = avialableFormats.count == 0 ? "default": avialableFormats[0].qualityLabel
                qualityTable.reloadData()
                do{
                    urlString = avialableFormats[currentFormat].url
                   await changeLength()
                    let (data, _) = try await URLSession.shared.data(from: URL(string: videoYUdata?.details.thumbnails.last?.url ?? "")!)
                    if let image = UIImage(data: data) {
                        previewImage.image = image
                    }
                }
            }else{
                let (length,image) = await presenter.getFileInformation(urlString:urlString)
                fileSizeLabel.text = length
                previewImage.image = image
            }
            
            
        }
    }
    
    func setSlideEffect(uiview:UIView,color:UIColor = UIColor(named: "primary")!){
        uiview.layer.cornerRadius = 10
        uiview.layer.shadowOpacity = 0.6
        uiview.layer.shadowOffset = CGSize.zero
        uiview.layer.shadowColor = color.cgColor
        uiview.layer.shadowRadius = 10
    }
    
    private func changeLength()async{
        let (length,_) = await presenter.getFileInformation(urlString:urlString,withImage: false)
        fileSizeLabel.text = length
    }
    
    
   @IBAction func downloadAction(_ sender: Any) {
       self.downloadButton.setTitle("Download", for: .normal)
       if  self.cancelButtonBottomConstraint.constant != 30{
           UIView.animate(withDuration: 1){ [self] in
               self.cancelButtonBottomConstraint.constant = 30
               self.cancelCardLabel.text = "Downloading file in progress ... "
               self.view.layoutIfNeeded()
           }
           if let url = URL(string: urlString){
               fileDownloader.isVideoType = isVideoType
               if fileDownloader.hasResumedData{
                   do{
                       let resumedData = try Data(contentsOf: fileDownloader.getFileURL())
                       fileDownloader.downloadFile(from: url,resumedData: resumedData)
                   }catch{
                       displayMessageInfo(message: "Error occured when retrieving old data.")
                   }
               }else{
                   fileDownloader.downloadFile(from: url)
               }
           }
       }
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.downloadButton.setTitle("Try again", for: .normal)
        fileDownloader.downloadTask?.cancel()
        fileDownloader.hasResumedData = false
    }
    
    @objc func videoTypeAction(sender: UITapGestureRecognizer){
        isVideoType = true
        videoTypeBar.backgroundColor = UIColor(named: "secondary")
        videoTypeLabel.textColor = UIColor(named: "secondary")
        audioTypeBar.backgroundColor = .clear
        audioTypeLabel.textColor = UIColor(named: "primary")
    }
    @objc func audioTypeAction(sender: UITapGestureRecognizer){
        isVideoType = false
        videoTypeBar.backgroundColor = .clear
        videoTypeLabel.textColor = UIColor(named: "primary")
        audioTypeBar.backgroundColor = UIColor(named: "secondary")
        audioTypeLabel.textColor = UIColor(named: "secondary")
    }
    
    @objc func qualitySelectAction(sender: UITapGestureRecognizer){
        qualitySelector.removeGestureRecognizer(qualitySelectorGesture)
        qualityTable.isHidden = false
        selectedQualityLabel.isHidden  = true
        UIView.animate(withDuration: 1){[self] in
            qualitySelectorHeightConstraint.constant = 200
            view.layoutIfNeeded()
        }
    }
    
    private func displayMessageInfo(message:String,backgroundColor:UIColor = UIColor(named: "error")!){
        DispatchQueue.main.async {[self] in
            UIView.animate(withDuration: 1,animations:{[self] in
                infoBar.backgroundColor = backgroundColor
                infoLabel.text = message
                infoLeftConstraint.constant = 25
                infoRightConstraint.constant = 25
                self.view.layoutIfNeeded()
            }){[self]_ in
                DispatchQueue.main.asyncAfter(deadline: .now()+5){
                    UIView.animate(withDuration: 1){[self] in
                        infoLeftConstraint.constant = width
                        infoRightConstraint.constant = -width
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
}


extension VideoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avialableFormats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = qualityTable.dequeueReusableCell(withIdentifier: QualityFormatCell.identifier, for: indexPath) as! QualityFormatCell
        cell.update(qualityLabel: avialableFormats[indexPath.row].qualityLabel ?? "")
        return cell
    }
}

extension VideoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        qualitySelector.addGestureRecognizer(qualitySelectorGesture)
        Task{
            urlString = avialableFormats[currentFormat].url
             await changeLength()
        }
        currentFormat  = indexPath.row
        selectedQualityLabel.text = avialableFormats[currentFormat].qualityLabel
        UIView.animate(withDuration: 1,animations: {[self] in
            qualitySelectorHeightConstraint.constant = 35
            view.layoutIfNeeded()
        }){[self]_ in
            qualityTable.isHidden = true
            selectedQualityLabel.isHidden  = false
        }
    }
}





extension VideoViewController: DownloadProgressDelegate{
    func completeFileName() -> String {
        var fileName = "Default Name"
        
        DispatchQueue.main.sync {
            if let text = fileNameTextField.text, !text.isEmpty {
                fileName = text
            }
        }
        
        return fileName + (isVideoType ? ".mp4" : ".m4a")
    }
    
    func updateProgress(progress: Float) {
        DispatchQueue.main.async {[self] in
            loadingProgress.updateProgress(percent: progress/100)
        }
    }
    
    func downloadFinishedWithSuccess() {
        DispatchQueue.main.async {[self] in
            UIView.animate(withDuration: 1,animations:{[self] in
                infoBar.backgroundColor = UIColor(named: "success")
                infoLabel.text = "Download succeed."
                infoLeftConstraint.constant = 25
                infoRightConstraint.constant = 25
                cancelButtonBottomConstraint.constant = -100
                loadingProgress.resetProgress()
                self.cancelCardLabel.text = "Click the button  to start downloading the video."
                self.view.layoutIfNeeded()
            }){ [self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+5){
                    UIView.animate(withDuration: 1){[self] in
                        infoLeftConstraint.constant = width
                        infoRightConstraint.constant = -width
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func downloadFinishedWithFailure(error:String) {
      
        DispatchQueue.main.async {[self] in
            self.downloadButton.setTitle("Try again", for: .normal)
            UIView.animate(withDuration: 1,animations:{[self] in
                infoBar.backgroundColor = UIColor(named: "error")
                infoLabel.text = error
                infoLeftConstraint.constant = 25
                infoRightConstraint.constant = 25
                cancelButtonBottomConstraint.constant = -100
                self.cancelCardLabel.text = "Click the button  to start downloading the video."
                self.view.layoutIfNeeded()
            }){[self]_ in
                DispatchQueue.main.asyncAfter(deadline: .now()+5){
                   
                    UIView.animate(withDuration: 1){[self] in
                        infoLeftConstraint.constant = width
                        infoRightConstraint.constant = -width
                        self.view.layoutIfNeeded()
                    }
                }
                
            }
        }
    }

  
}


