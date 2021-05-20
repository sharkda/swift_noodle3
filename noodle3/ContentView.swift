//
//  ContentView.swift
//  noodle3
//
//  Created by Jim Hsu on 2021/5/19.
//  based on youtubel: swiftUI2.0 Facebook Login

import SwiftUI
import FBSDKLoginKit
import FacebookShare

struct ContentView: View {
    var body: some View {
        VStack{
            FbLoginView()
            Divider()
            FbUglyShareUIController()
                .frame(width: 51, height: 51, alignment: .center)
        }
        .background(Color.yellow )
        .padding()
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
