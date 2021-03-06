//
//  ContentView.swift
//  noodle3
//
//  Created by Jim Hsu on 2021/5/19.
//  based on youtubel: swiftUI2.0 Facebook Login

import SwiftUI
import FBSDKLoginKit
import FacebookShare
import OSLog

fileprivate let logger = Logger(subsystem: myBundleId, category: "mainView")

struct ContentView: View {
    
    @State var showingProgressView:Bool = false
    @State var isFbSharing:Bool = false
    
    @Environment(\.presentationMode) var presentationMode //though we are not going to dismiss contentview...
    
    var body: some View {
        VStack{
            FbLoginView()
            Divider()
            Button(action:{
                    //audio2Video(aName: "bluebird15", aExt: "wav", vName: "bluebird15")
                    a2V2(aName: "bluebird15", aExt: "wav")
            }, label: {
                Text("A2V")
            })
            Divider()
            if isFbSharing{
                ProgressView()
            }
            FbUglyShareUIController(isSharing: $isFbSharing)
                .frame(width: fbButtonWidth * 3, height: fbButtonHeight * 3, alignment: .center)
            
        }
        .background(Color.yellow )
        .padding()
        .onAppear {
            logger.debug("onAppear")
        }
        .onDisappear(){
            logger.debug("onDisappear")
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .previewLayout(.sizeThatFits)
//    }
//}
//
//struct FbLoginView_Preview: PreviewProvider {
//    static var previews: some View {
//        FbLoginView()
//            .previewLayout(.sizeThatFits)
//    }
//}
struct FbLoginView: View{
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @State var manager = LoginManager()
    var body: some View{
        VStack(spacing:25){
            Button(action: {
                if logged{
                    manager.logOut()
                    email = ""
                    logged = false
                }else{
                    manager.logIn(permissions: ["public_profile", "email"], from: nil){ (result, err) in
                        if err != nil{
                            print(err?.localizedDescription)
                            return
                        }
                        logged = true
                        let request = GraphRequest(graphPath: "me",parameters: ["fields":"email"])
                        request.start{(_, res, _) in
                            //retuns dictionary
                            guard let profileData = res as? [String:Any] else {return}
                            //saving email
                            email = profileData["email"] as! String
                        }
                    }
                }
            }, label: {
                Text(logged ? "Logout" : "FB Login")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 35)
                    .background(Color.blue)
                    .clipShape(Capsule())
            })
            Text(email)
                .fontWeight(.bold)
            
        }
    }
}
