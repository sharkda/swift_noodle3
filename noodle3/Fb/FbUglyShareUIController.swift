//
//  FbShareController.swift
//  noodle3
//
//  Created by Jim Hsu on 2021/5/20.
//

import SwiftUI
import FacebookShare
import OSLog

fileprivate let LTag = "FbUglyShareUIController"

struct FbUglyShareUIController: UIViewControllerRepresentable {
    
    @Binding var isSharing:Bool
    
    class Coordinator:NSObject, MyFacebookUIDelegate{
        
        var parent: FbUglyShareUIController
        
        init(_ parent: FbUglyShareUIController){
            self.parent = parent
        }
        func onShareButtonClicked() {
            loggerFb.debug("\(LTag) ->Delegate::coordinator::onShareButtonClicked")
            parent.isSharing.toggle()
        }
        func onCompleted() {
            loggerFb.debug("\(LTag) ->Delegate::coordinator::onCompleted")
            parent.isSharing.toggle()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FbUglyShareUIController>) -> FacebookShareViewController {
        let fbShareViewController = FacebookShareViewController()
        fbShareViewController.delegate = context.coordinator
        return fbShareViewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}


//struct FbShareController:UIViewControllerRepresentable{
//
//    @Binding var sharingContent:ShareLinkContent
//
//    class Coordinator: NSObject, SharingDelegate{
//        func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
//            print(results)
//        }
//
//        func sharer(_ sharer: Sharing, didFailWithError error: Error) {
//            print(error.localizedDescription)
//        }
//
//        func sharerDidCancel(_ sharer: Sharing) {
//            print("cancelled: \(sharer.description) ")
//        }
//
//    }
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<FbShareController>) ->  ShareDialog {
//        let fbShareDialog = ShareDialog()
//        fbShareDialog.delegate = context.coordinator
//        return fbShareDialog
//    }
//    func updateUIViewController(_ uiViewController: FbShareController, context: UIViewControllerRepresentableContext<FbShareController>) {
//    }
//}
