//
//  GridView.swift
//  2048-Swift
//
//  Created by Alex Golub on 9/25/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import UIKit

public typealias Index = (x: Int, y: Int)
internal typealias GridData = (index: Index, frame: CGRect, nodeView: NodeView?)

protocol GridViewDelegate: class {
    func addToScore(value: UInt)
    func didThrow(error: Error)
}

final class GridView: UIView {

    let initialMatrix: [[Index]] // TODO: remove if possible
    var gridDatasArrays = [[GridData]]()
    
    weak var delegate: GridViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        var verticalRow = [[Index]]()
        for verticalIndex in 0...3 {
            var verticalArray = [Index]()
            for horizontalIndex in 0...3 {
                verticalArray.append((verticalIndex, horizontalIndex))
            }
            verticalRow.append(verticalArray)
        }
        self.initialMatrix = verticalRow
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
                
                var emptyGridData = try findRandomEmptyGridData()
                let nodeView = NodeView(index: emptyGridData.index,
                                        frame: emptyGridData.frame,
                                        value: UInt(newNodeValue))
                emptyGridData.nodeView = nodeView
                addToGrid(gridData: emptyGridData)

                addSubview(nodeView)
            } catch {
                delegate?.didThrow(error: error)
            }
        }
    }
    
    private func findRandomEmptyGridData() throws -> GridData {
        let emptyFieldsArray = emptyFields()
        
        guard !emptyFieldsArray.isEmpty,
            let gridData = emptyFieldsArray.randomElement() else {
                throw GameError.gameOver
        }
        
        return gridData
    }
    
    private func addToGrid(gridData: GridData) {
        guard let nodeView = gridData.nodeView else {
            return
        }
        
        var existingNode = gridDatasArrays[gridData.index.x][gridData.index.y]
        existingNode.nodeView = nodeView
        gridDatasArrays[gridData.index.x][gridData.index.y] = existingNode
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
        var rowsArray = [[GridData]]()
        for indexesArray in rowsIndexesArray {
            var rowArray = [GridData]()
            for index in indexesArray {
                rowArray.append(gridDatasArrays[index.x][index.y])
            }
            rowsArray.append(rowArray)
        }
        
        var newGridDatasArrays = [[GridData]]()
        rowsArray.forEach {
            let rowNodeViews = $0.filter { $0.nodeView != nil }
            if !rowNodeViews.isEmpty {
                let intsArray = createArrayOfIntsForSorting(array: $0)
                let sortedIntsArray = sort(array: intsArray)
                let sortedGridDatasArray = createGridDatasArray(initialArray: $0, intsArray: sortedIntsArray)
                newGridDatasArrays.append(sortedGridDatasArray)
            } else {
                newGridDatasArrays.append($0)
            }
        }
        gridDatasArrays = newGridDatasArrays

        redrawScreen()
    }
    
    private func redrawScreen() {
        removeAllNodeSubviews()
        drawGrid()
        
        // TODO: add new nodeView
    }
    
    private func createArrayOfIntsForSorting(array: [GridData]) -> [UInt] {
        var intsArray = [UInt]()
        for gridData in array {
            guard let nodeView = gridData.nodeView else {
                intsArray.append(0)
                continue
            }
            
            intsArray.append(nodeView.value)
        }
        
        return intsArray
    }
    
    private func createGridDatasArray(initialArray: [GridData], intsArray: [UInt]) -> [GridData] {
        var gridDatasArray = [GridData]()
        for (index, gridData) in initialArray.enumerated() {
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
                let nodeView = NodeView(index: gridData.index,
                                        frame: gridData.frame,
                                        value: intsArray[index])
                let newGridData: GridData = (index: gridData.index,
                                            frame: gridData.frame,
                                            nodeView: nodeView)
                gridDatasArray.append(newGridData)
            } else {
                let newGridData: GridData = (index: gridData.index,
                                            frame: gridData.frame,
                                            nodeView: nil)
                gridDatasArray.append(newGridData)
            }
        }
        
        return gridDatasArray
    }
    
    private func sort(array: [UInt]) -> [UInt] {
        var sortedGridArray = [UInt]()
        var makeBreakAfterMerge = false
        for (currentIndex, currentItem) in array.enumerated() {
            if makeBreakAfterMerge == false {
                let lastIndex = array.count - 1
                if currentIndex < lastIndex {
                    let nextIndex = currentIndex + 1
                    let nextItem = array[nextIndex]
                    if currentItem != 0 {
                        if currentItem != nextItem {
                            sortedGridArray.append(currentItem)
                        } else if currentItem == nextItem {
                            let newItem = currentItem + nextItem
                            sortedGridArray.append(newItem)
                            makeBreakAfterMerge = true
                            
                            delegate?.addToScore(value: newItem)
                        }
                    }
                } else if currentIndex == lastIndex, currentItem != 0 {
                    sortedGridArray.append(currentItem)
                }
            } else {
                makeBreakAfterMerge = false
                continue
            }
        }
        
        return sortedGridArray
    }
    
    // MARK: - Setup
    
    // TODO: make 4x4, 6x6, 8x8 etc by adjusting
    func setupGridView(height: CGFloat) {
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
        
        for (rowIndex, row) in initialMatrix.enumerated() {
            var gridArray = [GridData]()
            
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
                let gridData: GridData = (index: index,
                                        frame: nodeSuperviewFrame,
                                        nodeView: nil)
                gridArray.append(gridData)
            }
            gridDatasArrays.append(gridArray)
        }
    }
    
    private func drawGrid() {
        for gridDatasArray in gridDatasArrays {
            for gridData in gridDatasArray {
                if let nodeView = gridData.nodeView {
                    addSubview(nodeView)
                }
            }
        }
    }
    
    // MARK: - Utils
    
    private func emptyFields() -> [GridData] {
        return gridDatasArrays.flatMap { $0 }.filter { $0.nodeView == nil }
    }
    
    private func removeAllNodeSubviews() {
        subviews.forEach {
            if let nodeView = $0 as? NodeView {
                nodeView.removeFromSuperview()
            }
        }
    }
}
