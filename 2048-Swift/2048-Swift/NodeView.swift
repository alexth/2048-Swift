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
    let value: Int
    
    init(index: Index, frame: CGRect, value: Int) {
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
        backgroundColor = .white
        
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "\(value)"
        addSubview(label)
    }
}

