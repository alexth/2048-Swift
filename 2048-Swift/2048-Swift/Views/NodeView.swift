//
//  NodeView.swift
//  2048-Swift
//
//  Created by Alex Golub on 9/26/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import UIKit

final class NodeView: UIView {
    let index: Index
    var value: UInt
    
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
        backgroundColor = .white // TODO: depend on value
        
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "\(value)"
        addSubview(label)
    }
}
