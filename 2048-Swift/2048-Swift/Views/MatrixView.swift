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

protocol MatrixViewDelegate: class {
    func addToScore(value: UInt)
    func didThrow(error: Error)
}

final class MatrixView: UIView {

    let matrix: [[Index]] // TODO: remove if possible
    var matrixDatasArrays = [[MatrixData]]()
    
    weak var delegate: MatrixViewDelegate?
    
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
        roundCorners()
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
                                        value: UInt(newNodeValue))
                emptyMatrixData.nodeView = nodeView
                addToMatrix(nodeData: emptyMatrixData)

                addSubview(nodeView)
            } catch {
                delegate?.didThrow(error: error)
            }
        }
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
        
        var existingNode = matrixDatasArrays[nodeData.index.x][nodeData.index.y]
        existingNode.nodeView = nodeView
        matrixDatasArrays[nodeData.index.x][nodeData.index.y] = existingNode
    }
    
    // MARK: - Moves
    
    func didPerform(move: UISwipeGestureRecognizer.Direction) {
        switch move {
        case .left:
            leftMove()
        case .right:
            rightMove()
        case .up:
            upMove()
        case .down:
            downMove()
        default:
            fatalError("ERROR! Should not happen")
        }
    }
    
    private func leftMove() {
        // FIXME: - hardcoded for four rows
        let firstIndexesRow: [Index] = [(0, 0), (1, 0), (2, 0), (3, 0)]
        let secondIndexesRow: [Index] = [(0, 1), (1, 1), (2, 1), (3, 1)]
        let thirdIndexesRow: [Index] = [(0, 2), (1, 2), (2, 2), (3, 2)]
        let fourthIndexesRow: [Index] = [(0, 3), (1, 3), (2, 3), (3, 3)]
        let rowsIndexesArray = [firstIndexesRow, secondIndexesRow, thirdIndexesRow, fourthIndexesRow]
        handleMove(rowsIndexesArray: rowsIndexesArray)
    }
    
    private func rightMove() {
        // FIXME: - hardcoded for four rows
        let firstIndexesRow: [Index] = [(3, 0), (2, 0), (1, 0), (0, 0)]
        let secondIndexesRow: [Index] = [(3, 1), (2, 1), (1, 1), (0, 1)]
        let thirdIndexesRow: [Index] = [(3, 2), (2, 2), (1, 2), (0, 2)]
        let fourthIndexesRow: [Index] = [(3, 3), (2, 3), (1, 3), (0, 3)]
        let rowsIndexesArray = [firstIndexesRow, secondIndexesRow, thirdIndexesRow, fourthIndexesRow]
        handleMove(rowsIndexesArray: rowsIndexesArray)
    }
    
    private func upMove() {
        // TODO:
    }
    
    private func downMove() {
        // TODO:
    }
    
    private func handleMove(rowsIndexesArray: [[Index]]) {
        var rowsArray = [[MatrixData]]()
        for indexesArray in rowsIndexesArray {
            var rowArray = [MatrixData]()
            for index in indexesArray {
                rowArray.append(matrixDatasArrays[index.x][index.y])
            }
            rowsArray.append(rowArray)
        }
        
        var newMatrixDatasArrays = [[MatrixData]]()
        rowsArray.forEach {
            let rowNodeViews = $0.filter { $0.nodeView != nil }
            if !nodeViews.isEmpty {
                let intsArray = createArrayOfIntsForSorting(array: $0)
                let sortedIntsArray = sort(array: intsArray)
                let sortedMatrixDatasArray = createMatrixDatasArray(initialArray: $0, intsArray: sortedIntsArray)
                newMatrixDatasArrays.append(sortedMatrixDatasArray)
            } else {
                newMatrixDatasArrays.append($0)
            }
        }
        matrixDatasArrays = newMatrixDatasArrays

        redrawScreen()
    }
    
    private func redrawScreen() {
        removeAllNodeSubviews()
        drawMatrix()
        
        // TODO: add new nodeView
    }
    
    private func createArrayOfIntsForSorting(array: [MatrixData]) -> [UInt] {
        var intsArray = [UInt]()
        for matrixData in array {
            guard let nodeView = matrixData.nodeView else {
                intsArray.append(0)
                continue
            }
            
            intsArray.append(nodeView.value)
        }
        
        return intsArray
    }
    
    private func createMatrixDatasArray(initialArray: [MatrixData], intsArray: [UInt]) -> [MatrixData] {
        var matrixDatasArray = [MatrixData]()
        for (index, matrixData) in initialArray.enumerated() {
//            ;kajsdf;kjasdfjkdfj
//            if index < intsArray.count {
//                let nodeView = NodeView(index: matrixData.index,
//                                        frame: matrixData.frame,
//                                        value: intsArray[index])
//                let newMatrixData: MatrixData = (index: matrixData.index,
//                                                 frame: matrixData.frame,
//                                                 nodeView: nodeView)
//                matrixDatasArray.append(newMatrixData)
//            } else {
//                let newMatrixData: MatrixData = (index: matrixData.index,
//                                                 frame: matrixData.frame,
//                                                 nodeView: nil)
//                matrixDatasArray.append(newMatrixData)
//            }
            
            if index < intsArray.count {
                let nodeView = NodeView(index: matrixData.index,
                                        frame: matrixData.frame,
                                        value: intsArray[index])
                let newMatrixData: MatrixData = (index: matrixData.index,
                                                 frame: matrixData.frame,
                                                 nodeView: nodeView)
                matrixDatasArray.append(newMatrixData)
            } else {
                let newMatrixData: MatrixData = (index: matrixData.index,
                                                 frame: matrixData.frame,
                                                 nodeView: nil)
                matrixDatasArray.append(newMatrixData)
            }
        }
        
        return matrixDatasArray
    }
    
    private func sort(array: [UInt]) -> [UInt] {
        var sortedMatrixArray = [UInt]()
        var makeBreakAfterMerge = false
        for (currentIndex, currentItem) in array.enumerated() {
            if makeBreakAfterMerge == false {
                let lastIndex = array.count - 1
                if currentIndex < lastIndex {
                    let nextIndex = currentIndex + 1
                    let nextItem = array[nextIndex]
                    if currentItem != 0 {
                        if currentItem != nextItem {
                            sortedMatrixArray.append(currentItem)
                        } else if currentItem == nextItem {
                            let newItem = currentItem + nextItem
                            sortedMatrixArray.append(newItem)
                            makeBreakAfterMerge = true
                            
                            delegate?.addToScore(value: newItem)
                        }
                    }
                } else if currentIndex == lastIndex, currentItem != 0 {
                    sortedMatrixArray.append(currentItem)
                }
            } else {
                makeBreakAfterMerge = false
                continue
            }
        }
        
        return sortedMatrixArray
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
                let nodeSuperview = UIView(frame: nodeSuperviewFrame)
                nodeSuperview.backgroundColor = .lightGray
                nodeSuperview.roundCorners()
                addSubview(nodeSuperview)
                
                let index: Index = (x: node.x, y: node.y)
                let matrixData: MatrixData = (index: index,
                                              frame: nodeSuperviewFrame,
                                              nodeView: nil)
                matrixesArray.append(matrixData)
            }
            matrixDatasArrays.append(matrixesArray)
        }
    }
    
    private func drawMatrix() {
        for matrixDatasArray in matrixDatasArrays {
            for matrixData in matrixDatasArray {
                if let nodeView = matrixData.nodeView {
                    addSubview(nodeView)
                }
            }
        }
    }
    
    // MARK: - Utils
    
    private func emptyFields() -> [MatrixData] {
        return matrixDatasArrays.flatMap { $0 }.filter { $0.nodeView == nil }
    }
    
    private func removeAllNodeSubviews() {
        subviews.forEach {
            if let nodeView = $0 as? NodeView {
                nodeView.removeFromSuperview()
            }
        }
    }
}
