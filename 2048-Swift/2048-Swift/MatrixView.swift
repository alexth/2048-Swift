//
//  MatrixView.swift
//  2048-Swift
//
//  Created by Alex Golub on 9/25/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import UIKit

public typealias Index = (x: Int, y: Int)
internal typealias MatrixData = (index: Index, frame: CGRect, nodeView: NodeView?)

public enum GameError: String, Error {
    case gameOver = "Game Over"
}

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
        label.backgroundColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "\(value)"
        addSubview(label)
    }
}

final class MatrixView: UIView {

    let matrix: [[Index]]
    var matrixData = [[MatrixData]]()
    
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
    }
    
    // MARK: - Actions
    
    func startGame() {
        for _ in 0...1 {
            do {
                guard let newNodeValue = [2, 4].randomElement() else {
                    return
                }
                
                var emptyMatrixData = try findRandomEmptyMatrixData()
                let nodeView = NodeView(index: emptyMatrixData.index,
                                        frame: emptyMatrixData.frame,
                                        value: newNodeValue)
                emptyMatrixData.nodeView = nodeView
                addToMatrix(nodeData: emptyMatrixData)

                addSubview(nodeView)
            } catch {
                print(error)
            }
        }
    }
    
    func didPerform(move: UISwipeGestureRecognizer.Direction) {
        switch move {
        case .left:
            print(move)
        case .right:
            print(move)
        case .up:
            print(move)
        case .down:
            print(move)
        default:
            fatalError("ERROR! Should not happen")
        }
        
        // TODO:
        
    }
    
    private func findRandomEmptyMatrixData() throws -> MatrixData {
        let emptyFieldsArray = emptyFields()
        
        guard !emptyFieldsArray.isEmpty,
            let matrixData = emptyFieldsArray.randomElement() else {
                throw GameError.gameOver
        }
        
        return matrixData
    }
    
    private func addToMatrix(nodeData: MatrixData) {
        guard let nodeView = nodeData.nodeView else {
            return
        }
        
        var existingNode = matrixData[nodeData.index.x][nodeData.index.y]
        existingNode.nodeView = nodeView
        matrixData[nodeData.index.x][nodeData.index.y] = existingNode
    }
    
    // MARK: - Setup
    
    // TODO: make 4x4, 6x6, 8x8 etc by adjusting
    func setupMatrixView(height: CGFloat) {
//    private func setupMatrixView() {
//        let x1 = UIScreen.main.scale
//        let x2 = UIScreen.main.nativeScale
//        let x3 = UIScreen.main.bounds
//        let x4 = UIScreen.main.nativeBounds
//        let framex = frame
//        let boundsx = bounds
        // TODO:
//        let verticalInset = CGFloat(bounds.height / 29)
//        let horizontalInset = CGFloat(bounds.width / 29)
        let verticalInset = CGFloat(height / 29)
        let horizontalInset = CGFloat(height / 29)
        let horizontalSide = CGFloat(verticalInset * 6)
        let verticalSide = CGFloat(verticalInset * 6)
        
        for (rowIndex, row) in matrix.enumerated() {
            var matrixesArray = [MatrixData]()
            
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
                
                let index: Index = (x: node.x, y: node.y)
                let matrixData: MatrixData = (index: index,
                                              frame: nodeSuperviewFrame,
                                              nodeView: nil)
                matrixesArray.append(matrixData)
            }
            matrixData.append(matrixesArray)
        }
    }
    
    // MARK: - Utils
    
    private func emptyFields() -> [MatrixData] {
        // TODO:
        return matrixData.flatMap { $0 }.filter { $0.nodeView == nil }
    }
}
