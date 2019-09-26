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
        
//        for x in matrix {
//            for y in x {
//                print(y)
//            }
//        }
        
        super.init(coder: aDecoder)
        setupMatrixView()
    }
    
    // MARK: - Setup
    
    // TODO: make 4x4, 6x6, 8x8 etc by adjusting
    private func setupMatrixView() {
//        let x1 = UIScreen.main.scale
//        let x2 = UIScreen.main.nativeScale
//        let x3 = UIScreen.main.bounds
//        let x4 = UIScreen.main.nativeBounds
//        let framex = frame
//        let boundsx = bounds
        let verticalInset = CGFloat(bounds.height / 29)// / UIScreen.main.nativeScale
        let horizontalInset = CGFloat(bounds.width / 29)// / UIScreen.main.nativeScale
        let horizontalSide = CGFloat(verticalInset * 6)
        let verticalSide = CGFloat(verticalInset * 6)
        
        for (rowIndex, row) in matrix.enumerated() {
            let xInset = (CGFloat(rowIndex) * CGFloat(horizontalSide)) + (verticalInset * CGFloat(rowIndex + 1))
            for node in row {
                let yInset = (CGFloat(node.y) * CGFloat(verticalSide)) + (horizontalInset * CGFloat(node.y + 1))
                let nodeSuperviewFrame = CGRect(x: xInset,
                                                y: yInset,
                                                width: horizontalSide,
                                                height: verticalSide)
//                print(nodeSuperviewFrame)
                let nodeSuperview = UIView(frame: nodeSuperviewFrame)
                nodeSuperview.backgroundColor = .lightGray
                addSubview(nodeSuperview)
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
