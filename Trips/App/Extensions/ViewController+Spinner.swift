//
//  ViewController+Spinner.swift
//  Trips
//
//  Created by AGUJARI Erik on 04/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import UIKit

final class SpinnerView: UIView { }

protocol SpinnerProtocol {
    func showSpinner()
    func hideSpinner()
    func showError(message: String, completion: (() -> Void)?)
}

extension SpinnerProtocol {
    func showError(message: String, completion: (() -> Void)? = nil) {
        return showError(message: message, completion: completion)
    }
}

extension UIViewController: SpinnerProtocol {
    func showSpinner() {
        let spinnerView = SpinnerView(frame: view.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center

        spinnerView.addSubview(activityIndicator)
        view.addSubview(spinnerView)
    }

    func hideSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let spinnerView = self?.view.subviews.first(where: { $0 is SpinnerView }) else { return }

            spinnerView.removeFromSuperview()
        }
    }

    func showError(message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
                completion?()
            }
            let alertController = UIAlertController(title: "Oops!",
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true)
        }

    }
}
