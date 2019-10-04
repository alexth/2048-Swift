//
//  NodeView.swift
//  2048-Swift
//
//  Created by Alex Golub on 9/26/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import UIKit

enum NodeViewAnimation {
    case appearance
    case disappearance
    case move
    case merge
}

final class NodeView: UIView {
    let index: Index
    let value: UInt
    
    private let animationDuration = TimeInterval(0.2)
    
    init(index: Index, frame: CGRect, value: UInt) {
        self.index = index
        self.value = value
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        roundCorners()
        
        backgroundColor = UIColor(named: "\(value)")
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "\(value)"
        if value > 4 {
            label.textColor = .white
        }
        addSubview(label)
    }
    
    private func animateAppearance() {
        transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
        UIView.animate(withDuration: animationDuration) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }
    }
    
    private func animateMerge() {
        UIView.animate(withDuration: animationDuration,
                       animations: {
                        self.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }) { completed in
            UIView.animate(withDuration: self.animationDuration) {
                self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
        }
    }
    
    private func animateDisappearance() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.0
        }
    }
}
