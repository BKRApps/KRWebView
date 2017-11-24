//
//  ImagePicker.swift
//  KRWebView
//
//  Created by Birapuram Kumar Reddy on 11/24/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import UIKit

class ImagePicker : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var imagePickerController : UIImagePickerController!
    var completionHandler : ((URLResponse?,Data?) -> Void)?

    func showGallery(cHandler: @escaping (URLResponse?,Data?) -> Void) -> Void {
        if let viewController = UIApplication.shared.delegate?.window??.rootViewController {
            completionHandler = cHandler
            imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            viewController.present(imagePickerController, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let data = UIImagePNGRepresentation(image) as Data? {
                let response = URLResponse(url: URL(string: "custom-scheme://")!, mimeType: "image/png", expectedContentLength: data.count, textEncodingName: nil);
                completionHandler!(response,data)
            }
        }
    }
}
