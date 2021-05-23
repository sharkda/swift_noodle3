/**
 to share an audio turns out tricky
 
 */

import FacebookShare
import UIKit
import OSLog

fileprivate let LTag = "facebookShareViewController"

let fbButtonWidth:CGFloat = 36
let fbButtonHeight:CGFloat = 36

class FacebookShareViewController: UIViewController {
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        let urlBtn = UIButton(type: .system)
        urlBtn.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Share", for: .normal)
        urlBtn.setImage(UIImage(named: "fb128"), for: .normal)
        //urlBtn.center = view.center
        urlBtn.backgroundColor = .clear
        
        let videoBtn = UIButton(type: .system)
        videoBtn.translatesAutoresizingMaskIntoConstraints = false
        videoBtn.setTitle("video", for: .normal)
        videoBtn.backgroundColor = UIColor.yellow
        #if targetEnvironment(simulator)
        videoBtn.addTarget(self,action: #selector(psuodoVideo), for: .touchUpInside)
        #else
        videoBtn.addTarget(self, action: "shareV2Fb", for: .touchUpInside)
        #endif
        
        #if targetEnvironment(simulator)
        urlBtn.addTarget(self,action: #selector(psuodoShareLink), for: .touchUpInside)
        #else
        urlBtn.addTarget(self, action: "shareLink", for: .touchUpInside)
        #endif
       
        view.addSubview(urlBtn)
        view.addSubview(videoBtn)
        NSLayoutConstraint.activate([
            urlBtn.widthAnchor.constraint(equalToConstant:fbButtonWidth),
            urlBtn.heightAnchor.constraint(equalToConstant: fbButtonHeight),
            urlBtn.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 0),
            videoBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])
    }
    
    @objc func psuodoVideo(){
        print("\(LTag) --  video?")
    }
    
    @objc func psuodoShareLink(){
        print("\(LTag) -- psudoSharlink ")
    }

    @IBAction func shareLink() {
        guard let url = URL(string: "https://newsroom.fb.com/") else {
            preconditionFailure("URL is invalid")
        }

        let content = ShareLinkContent()
        content.contentURL = url
        content.hashtag = Hashtag("#bestSharingSampleEver")

        dialog(withContent: content).show()
    }
    
    //turns out this will add video into the photolib first... wth
    func createAssetURL(url: URL, completion: @escaping (String) -> Void) {
               let photoLibrary = PHPhotoLibrary.shared()
               var videoAssetPlaceholder:PHObjectPlaceholder!
               photoLibrary.performChanges({
                   let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                   videoAssetPlaceholder = request!.placeholderForCreatedAsset
               },
                   completionHandler: { success, error in
                       if success {
                           let localID = NSString(string: videoAssetPlaceholder.localIdentifier)
                           let assetID = localID.replacingOccurrences(of: "/.*", with: "", options: NSString.CompareOptions.regularExpression, range: NSRange())
                           let ext = "mp4"
                           let assetURLStr =
                           "assets-library://asset/asset.\(ext)?id=\(assetID)&ext=\(ext)"

                           completion(assetURLStr)
                       }
               })
           }
    
    @objc func shareV2Fb(){
        let content: ShareVideoContent = ShareVideoContent()
        let videoURLs = Bundle.main.url(forResource: "v0", withExtension: "mov")!
        createAssetURL(url: videoURLs) { url in
            let video = ShareVideo()
            video.videoURL = URL(string: url)
            content.video = video
            
            let shareDialog = ShareDialog()
            shareDialog.shareContent = content
            shareDialog.mode = .native
            shareDialog.delegate = self
            shareDialog.show()
        }
    }

    
    @objc func zz_myShareVideo(){
//        let dataAsset = NSDataAsset(name: "v0")
//        if dataAsset == nil {presentAlert(title: "data", message: "NSDataAsset is nil")}
        let videoUrl = Bundle.main.url(forResource: "v0", withExtension: "mov")!
        //let video = ShareVideo(data: dataAsset!.data)
        let video = ShareVideo()
        video.videoURL = videoUrl
        let content = ShareVideoContent()
        content.video = video
        let dialog = self.dialog(withContent: content)
        do{
            try dialog.validate()
        }catch{
            print(error.localizedDescription)
            presentAlert(for: error)
        }
    }
    
    @IBAction func sharePhoto() {
        #if targetEnvironment(simulator)
        presentAlert(
            title: "Error",
            message: "Sharing an image will not work on a simulator. Please build to a device and try again."
        )
        return
        #endif

        guard let image = UIImage(named: "puppy") else {
            presentAlert(
                title: "Invalid image",
                message: "Could not find image to share"
            )
            return
        }

        let photo = SharePhoto(image: image, userGenerated: true)
        let content = SharePhotoContent()
        content.photos = [photo]

        let dialog = self.dialog(withContent: content)

        // Recommended to validate before trying to display the dialog
        do {
            try dialog.validate()
        } catch {
            presentAlert(for: error)
        }

        dialog.show()
    }

    func dialog(withContent content: SharingContent) -> ShareDialog {
        return ShareDialog(
            fromViewController: self,
            content: content,
            delegate: self
        )
    }

}

extension FacebookShareViewController: SharingDelegate {

    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print(results)
    }

    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        presentAlert(for: error)
    }

    func sharerDidCancel(_ sharer: Sharing) {
        presentAlert(title: "Cancelled", message: "Sharing cancelled")
    }


}
