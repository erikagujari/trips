//
//  HomeViewController.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import MapKit

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModelProtocol = HomeViewModel()
    private var mapView: MKMapView?
    private var tableView: UITableView?
    private var contactButton: UIButton?

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.retrieveTrips()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    //MARK: Private
    private func setupUI() {
        view.backgroundColor = .white
        setupMap()
        setupTableView()
        setupContactButton()
    }

    private func setupMap() {
        mapView = MKMapView()
        guard let mapView = mapView else { return }
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                                     multiplier: Constants.mapViewMultiplier)])
    }

    private func setupTableView() {
        tableView = UITableView()
        guard let tableView = tableView,
            let mapView = mapView
            else { return }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }

    private func setupContactButton() {
        contactButton = UIButton()
        guard let contactButton = contactButton else { return }
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contactButton)
        //TODO: add asset
        NSLayoutConstraint.activate([contactButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                                             constant: -Constants.defaultMargin),
                                     contactButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                                        constant: Constants.defaultMargin)])
    }
}

private extension HomeViewController {
    enum Constants {
        static let mapViewMultiplier: CGFloat = 0.6
        static let defaultMargin: CGFloat = 20
    }
}
