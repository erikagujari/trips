//
//  HomeViewController.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import MapKit
import Combine

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModelProtocol = HomeViewModel()
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    private var mapView: MKMapView?
    private var tableView: UITableView?
    private var contactButton: UIButton?

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
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

    private func setupBinding() {
        viewModel.$cellModels.sink { [weak self] cells in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }.store(in: &cancellable)

        viewModel.$isFetching.sink { [weak self] isFetching in
            isFetching ? self?.showSpinner() : self?.hideSpinner()
        }.store(in: &cancellable)

        viewModel.$errorMessage.sink(receiveValue: { [weak self] message in
            guard !message.isEmpty else { return }

            self?.showError(message: message, completion: {
                self?.viewModel.retrieveTrips()
            })
        }).store(in: &cancellable)
    }

    private func setupMap() {
        mapView = MKMapView()
        mapView?.delegate = self
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.description())
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

    private func setMap(route: [CLLocationCoordinate2D]) {
        removeRoutes()
        let polyline = MKPolyline(coordinates: route, count: route.count)
        mapView?.addOverlay(polyline)
        centerMap(on: polyline)
    }

    private func centerMap(on polyline: MKPolyline) {
        var regionRect = polyline.boundingMapRect
        let widthPadding = regionRect.size.width * 0.25
        let heightPadding = regionRect.size.height * 0.25

        regionRect.size.width += widthPadding
        regionRect.size.height += heightPadding

        regionRect.origin.x -= widthPadding / 2
        regionRect.origin.y -= heightPadding / 2

        mapView?.setRegion(MKCoordinateRegion(regionRect), animated: true)
    }

    private func removeRoutes() {
        guard let overlays = mapView?.overlays else {
            return
        }
        mapView?.removeOverlays(overlays)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.description(), for: indexPath) as? HomeTableViewCell,
            viewModel.cellModels.indices.contains(indexPath.row)
            else {
                return UITableViewCell()
        }

        cell.configure(model: viewModel.cellModels[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setMap(route: viewModel.route(forTrip: indexPath.row))
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer( )}

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = Constants.polylineWidth
        return renderer
    }
}

private extension HomeViewController {
    enum Constants {
        static let mapViewMultiplier: CGFloat = 0.6
        static let defaultMargin: CGFloat = 20
        static let polylineWidth: CGFloat = 3
    }
}
