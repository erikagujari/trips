//
//  StopDetailView.swift
//  Trips
//
//  Created by AGUJARI Erik on 06/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import UIKit

final class StopDetailView: UIView {
    private let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let priceAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let stopLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let stopTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let paidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let paidValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let addressValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: Private
    private func setupLayout() {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        addSubview(contentStackView)
        NSLayoutConstraint.activate([contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     contentStackView.topAnchor.constraint(equalTo: topAnchor),
                                     contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        let nameStackView = UIStackView()
        nameStackView.axis = .horizontal
        nameStackView.addArrangedSubview(userLabel)
        nameStackView.addArrangedSubview(userNameLabel)

        let priceStackView = UIStackView()
        priceStackView.axis = .horizontal
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceAmountLabel)

        let timeStackView = UIStackView()
        timeStackView.axis = .horizontal
        timeStackView.addArrangedSubview(stopLabel)
        timeStackView.addArrangedSubview(stopTimeLabel)

        let paidStackView = UIStackView()
        paidStackView.axis = .horizontal
        paidStackView.addArrangedSubview(paidLabel)
        paidStackView.addArrangedSubview(paidValueLabel)

        let addressStackView = UIStackView()
        addressStackView.axis = .horizontal
        addressStackView.addArrangedSubview(addressLabel)
        addressStackView.addArrangedSubview(addressValueLabel)

        contentStackView.addArrangedSubview(nameStackView)
        contentStackView.addArrangedSubview(priceStackView)
        contentStackView.addArrangedSubview(timeStackView)
        contentStackView.addArrangedSubview(paidStackView)
        contentStackView.addArrangedSubview(addressStackView)
    }
}

extension StopDetailView {
    func configure(model: StopAnnotationModel) {
        userLabel.text = Titles.user
        userNameLabel.text = model.userName
        priceLabel.text = Titles.price
        priceAmountLabel.text = model.price
        stopLabel.text = Titles.time
        stopTimeLabel.text = model.stopTime
        priceLabel.text = Titles.price
        priceAmountLabel.text = model.price
        addressLabel.text = Titles.address
        addressValueLabel.text = model.address
        sizeToFit()
    }
}

private extension StopDetailView {
    enum Titles {
        static let user = "User:"
        static let price = "Price:"
        static let time = "Time:"
        static let paid = "Paid:"
        static let address = "Address:"
    }
}
