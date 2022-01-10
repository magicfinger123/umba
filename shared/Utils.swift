//
//  Utils.swift
//  Umba
//
//  Created by CWG Mobile Dev on 06/01/2022.
//

import Foundation
import UIKit
import Reusable
import RxCocoa
import RxSwift
import Kingfisher
import SDWebImage
import SVGKit
import AVKit
import AVFoundation
import KVNProgress

func embedImage(imageItem: UIImageView, url: String, cornerRadius:CGFloat = 20){
    let imgURL: URL? = URL(string: url)
    let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
    imageItem.kf.indicatorType = .activity
    imageItem.kf.setImage(with: imgURL, placeholder: UIImage(named: "placeholder"), options: [.processor(processor),.cacheOriginalImage,.transition(.fade(0.25))])
    {
        result in
        switch result {
        case .success(_):
            break
        case .failure(_):
            imageItem.kf.setImage(with: imgURL, placeholder: nil, options: [.processor(SVGImgProcessor())])
        }
    }
}

public struct SVGImgProcessor:ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}
