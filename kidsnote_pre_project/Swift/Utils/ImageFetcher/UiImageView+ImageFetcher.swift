//
//  UiImageView.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import UIKit
import Combine

extension UIImageView {
    
    private struct AssociatedKeys {
        static var cancellableKey = "cancellableKey"
        static var activityIndicatorKey = "activityIndicatorKey"
    }
    
    private var cancellable: AnyCancellable? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cancellableKey) as? AnyCancellable
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cancellableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        if let indicator = objc_getAssociatedObject(self, &AssociatedKeys.activityIndicatorKey) as? UIActivityIndicatorView {
            return indicator
        } else {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.hidesWhenStopped = true
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(indicator)
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return indicator
        }
    }
    
    func setImage(with urlStr: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        self.activityIndicator.startAnimating()
        
        cancellable?.cancel()
        
        cancellable = ImageFetcher.default.loadImage(urlStr: urlStr)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.activityIndicator.stopAnimating()
                switch response {
                case .success(let image):
                    self?.image = image
                case .error(let error):
                    print("Failed to load image: \(error.message)")
                }
            }
    }
}
