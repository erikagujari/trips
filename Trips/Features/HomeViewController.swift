//
//  HomeViewController.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import MapKit

final class HomeViewController: UIViewController {
    private var mapView: MKMapView?
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    //MARK: Private
    private func setupUI() {
        view.backgroundColor = .white
        setupMap()
    }

    private func setupMap() {
        mapView = MKMapView()
        guard let mapView = mapView
            else { return }
        //TODO: move this into an extension
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        let constraints = [
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

