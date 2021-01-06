//
//  UIView+Extensions.swift
//  recorda
//
//  Created by Alex Morral on 19/02/2020.
//  Copyright © 2020 Bocadil Infinite SL. All rights reserved.
//

import UIKit.UIView

extension UIView {
    func addAndPin(view: UIView, insets: UIEdgeInsets = .zero) {
        
        addSubview(view)
        view.pin(to: self, insets: insets)
        
    }
    
    func pin(to pinned: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: pinned.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: pinned.bottomAnchor, constant: -1 * insets.bottom),
            leadingAnchor.constraint(equalTo: pinned.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: pinned.trailingAnchor, constant: -1 * insets.right)
        ])
    }
    
    func removeSubviews() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
    }
}
