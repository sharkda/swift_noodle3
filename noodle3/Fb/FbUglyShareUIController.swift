//
//  FbShareController.swift
//  noodle3
//
//  Created by Jim Hsu on 2021/5/20.
//

import SwiftUI
import FacebookShare

struct FbUglyShareUIController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FbUglyShareUIController>) -> FacebookShareViewController {
        FacebookShareViewController()
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
