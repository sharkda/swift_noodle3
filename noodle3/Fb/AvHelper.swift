//
//  AvHelper.swift
//  noodle3
//
//  Created by Jim Hsu on 2021/5/22.
//

/**
 https://github.com/dev-labs-bg/swift-video-generator/blob/master/Example/SwiftVideoGenerator/ViewController.swift
 */

import Foundation
import SwiftVideoGenerator
import Combine
import OSLog

fileprivate let LTag = "A2V"




func a2VFuture(audioFileUrl:URL, vName:String ) -> Future<URL, Error>{
    return Future { promise in
        print("a2vFuture")
        VideoGenerator.fileName = vName
        VideoGenerator.shouldOptimiseImageForVideo = true
        VideoGenerator.current.generate(withImages: [#imageLiteral(resourceName: "tt2b")], andAudios: [audioFileUrl], andType: .single,{ (progress) in print("progress \(progress)")}){ result in
            print("")
            switch result{
            case .success(let url):
                promise(.success(url))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}

var cancellables = Set<AnyCancellable>()

func a2V2(aName:String, aExt:String){
    if let audioURL = Bundle.main.url(forResource: aName , withExtension: aExt){
        a2VFuture(audioFileUrl: audioURL, vName: aName)
            .print()
            .sink(receiveCompletion: { completion in
                print("receiveCompletion \(completion)")
            }, receiveValue: { value in
                print("receiveValue \(value)")
            })
            .store(in: &cancellables)
    }else{
        print("52 no file")
    }
}



func audio2Video(aName:String, aExt:String, vName:String){
    if let audioURL4 = Bundle.main.url(forResource: aName , withExtension: aExt) {
      //LoadingView.lockView()

      VideoGenerator.fileName = vName
      VideoGenerator.shouldOptimiseImageForVideo = true
      //let uiImage0 = UIImage(imageLiteralResourceName: "tt2")
        VideoGenerator.current.generate(withImages: [#imageLiteral(resourceName: "tt2b")], andAudios: [audioURL4], andType: .single, { (progress) in
        print(progress)
      }){
        (result) in
        switch result{
        case .success(let url):
            print(url)
        case .failure(let error):
            print(error)
        }
      }
    }
}
