//
//  MatrixView.swift
//  2048-Swift
//
//  Created by Alex Golub on 9/25/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import UIKit

public typealias Index = (x: Int, y: Int)

final class NodeView: UIView {
    let index: Index
    let value: Int
    
    init(index: Index, frame: CGRect, value: Int) {
        self.index = index
        self.value = value
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MatrixView: UIView {

    let matrix: [[Index]]
//    let matrix1: [[(Index, CGRect)]]
    
    required init?(coder aDecoder: NSCoder) {
        var verticalRow = [[Index]]()
        for verticalIndex in 0...3 {
            var verticalArray = [Index]()
            for horizontalIndex in 0...3 {
                verticalArray.append((verticalIndex, horizontalIndex))
            }
            verticalRow.append(verticalArray)
        }
        self.matrix = verticalRow
        
        super.init(coder: aDecoder)
        setupMatrixView()
    }
    
    // MARK: - Setup
    
    private func setupMatrixView() {
        let inset = CGFloat(frame.height / 30)
        let size = CGFloat(inset * 6)
        
        for row in matrix {
            var xInset = CGFloat(1)
            for node in row {
//                print(node)
                xInset += 1
                let nodeSuperviewFrame = CGRect(x: inset * xInset,
                                                y: inset,
                                                width: size,
                                                height: size)
                let nodeSuperview = UIView(frame: nodeSuperviewFrame)
                nodeSuperview.backgroundColor = .white
                addSubview(nodeSuperview)
                print(nodeSuperview.frame)
            }
        }
    }
    
    private func startGame() {
        // TODO:
    }
    
    private func addNode() throws {
        // TODO:
    }
}
