//
//  URLLoader.swift
//  Munch
//
//  Created by Sean Lissner on 14.11.18.
//

import Foundation
import UIKit
import SafariServices

class URLLoader: NSObject{
    func loadLink(_ urlString: String, vc:UIViewController) {
        let url = URL(string: urlString)
        let safari = SFSafariViewController.init(url: url!)
        safari.delegate = self
        if #available(iOS 11.0, *) {
            safari.dismissButtonStyle = .close
        } else {
            // Fallback on earlier versions
        }
        vc.present(safari, animated: true, completion: {
            print("Safari Opened with URL: \(urlString)")
        })
    }
}

extension URLLoader : SFSafariViewControllerDelegate {
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("URL Loader completed loading the URL requested")
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("URL Loader completed loading the URL requested")
    }
}
