//
//  HomeTableViewCell.swift
//  Trips
//
//  Created by AGUJARI Erik on 04/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import UIKit

final class HomeTableViewCell: UITableViewCell {
    private let driverTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let driverNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let originTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let originAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let originTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let destinationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let destinationAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let destinationTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: Private
    private func setupLayout() {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = Constants.verticalSpacing
        contentStackView.adjust(to: contentView)

        let driverStackView = UIStackView()
        driverStackView.axis = .horizontal
        driverStackView.alignment = .leading
        driverStackView.spacing = Constants.horizontalSpacing
        driverStackView.addArrangedSubview(driverTitleLabel)
        driverStackView.addArrangedSubview(driverNameLabel)
        contentStackView.addArrangedSubview(driverStackView)

        let originStackView = UIStackView()
        originStackView.axis = .horizontal
        originStackView.alignment = .leading
        originStackView.spacing = Constants.horizontalSpacing
        let originContentStackView = UIStackView()
        originContentStackView.axis = .horizontal
        originContentStackView.spacing = Constants.horizontalSpacing
        originContentStackView.alignment = .leading
        let originTimeStackView = UIStackView()
        originTimeStackView.axis = .vertical
        originTimeStackView.alignment = .leading
        originTimeStackView.spacing = Constants.verticalSpacing

        originTimeStackView.addArrangedSubview(originAddressLabel)
        originTimeStackView.addArrangedSubview(originTimeLabel)
        originContentStackView.addArrangedSubview(originTimeStackView)
        originStackView.addArrangedSubview(originTitleLabel)
        originStackView.addArrangedSubview(originContentStackView)
        contentStackView.addArrangedSubview(originStackView)

        let destinationStackView = UIStackView()
        destinationStackView.axis = .horizontal
        destinationStackView.spacing = Constants.horizontalSpacing
        destinationStackView.alignment = .leading
        let destinationContentStackView = UIStackView()
        destinationContentStackView.axis = .horizontal
        destinationContentStackView.spacing = Constants.horizontalSpacing
        destinationContentStackView.alignment = .leading
        let destinationTimeStackView = UIStackView()
        destinationTimeStackView.axis = .vertical
        destinationTimeStackView.spacing = Constants.verticalSpacing
        destinationTimeStackView.alignment = .leading

        destinationTimeStackView.addArrangedSubview(destinationAddressLabel)
        destinationTimeStackView.addArrangedSubview(destinationTimeLabel)
        destinationContentStackView.addArrangedSubview(destinationTimeStackView)
        destinationStackView.addArrangedSubview(destinationTitleLabel)
        destinationStackView.addArrangedSubview(destinationContentStackView)
        contentStackView.addArrangedSubview(destinationStackView)

        NSLayoutConstraint.activate([driverNameLabel.leadingAnchor.constraint(equalTo: originContentStackView.leadingAnchor),
                                    driverNameLabel.leadingAnchor.constraint(equalTo: destinationContentStackView.leadingAnchor)])
    }
}

extension HomeTableViewCell {
    func configure(model: HomeCellModel) {
        driverTitleLabel.text = Titles.driver
        driverNameLabel.text = model.driverName
        originTitleLabel.text = Titles.origin
        originAddressLabel.text = model.originAddress
        originTimeLabel.text = model.startTime
        destinationTitleLabel.text = Titles.destination
        destinationAddressLabel.text = model.destinationAddress
        destinationTimeLabel.text = model.endTime
    }
}

private extension HomeTableViewCell {
    enum Constants {
        static let verticalSpacing: CGFloat = 5.0
        static let horizontalSpacing: CGFloat = 10
    }

    enum Titles {
        static let driver = "Driver:"
        static let origin = "Origin:"
        static let destination = "Destination:"
    }
}
