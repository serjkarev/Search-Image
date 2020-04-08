//
//  Extensions.swift
//  Search Image
//
//  Created by MacBook Pro on 4/8/20.
//  Copyright © 2020 skarev. All rights reserved.
//

import UIKit

fileprivate var activityView: UIView?

extension UIViewController {
    func showSpinner() {
        activityView = UIView(frame: UIScreen.main.bounds)
        activityView?.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = activityView!.center
        activityIndicator.startAnimating()
        activityView?.addSubview(activityIndicator)
        self.view.addSubview(activityView!)
    }
    
    func removeSpinner() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
