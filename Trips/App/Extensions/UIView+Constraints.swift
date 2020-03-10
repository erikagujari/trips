//
//  UIView+Constraints.swift
//  Trips
//
//  Created by AGUJARI Erik on 10/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import UIKit

extension UIView {
    func adjust(to contentView: UIView, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, topConstraint: NSLayoutYAxisAnchor? = nil, bottom: CGFloat = 0, safeArealayoutGuide: Bool = false) {
        let layoutGuide = safeArealayoutGuide ? contentView.safeAreaLayoutGuide : contentView.layoutMarginsGuide
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self)
        NSLayoutConstraint.activate([leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: leading),
                                     trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: trailing),
                                     topAnchor.constraint(equalTo: topConstraint ?? layoutGuide.topAnchor, constant: top),
                                     bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: bottom)])
    }
}
