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
internal typealias MoveData = (value: UInt, animationType: NodeViewAnimationType?)
internal typealias AnimatedGridData = (gridData: GridData, animationType: NodeViewAnimationType?)

enum NodeViewAnimationType {
    case move(from: CGRect)
    case merge
}

protocol GridViewDelegate: class {
    func addToScore(value: UInt)
    func didThrow(error: Error)
}

final class GridView: UIView {

    var gridDatasArrays = [[GridData]]()
    weak var delegate: GridViewDelegate?
    private var height: CGFloat = 0.0
    private var gridCount: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        roundCorners()
    }
    
    // MARK: - Actions
    
    func startGame() {
        cleanupGridDatasArray()
        removeAllNodeSubviews()
        setupGridView(height: height, gridCount: gridCount)
        for _ in 0...1 {
            putNodeOnAFreeField()
        }
    }
    
    func removeAllNodeSubviews() {
        var viewsToRemove = [UIView]()
        subviews.forEach {
            if let nodeView = $0 as? NodeView {
                nodeView.removeFromSuperview()
                viewsToRemove.append(nodeView)
            }
        }
        
        viewsToRemove.removeAll()
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
        handleMove(rowsIndexesArray: Calculator.calculateInitialIndexes(gridCount: gridDatasArrays.count, move: move))
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
        
        rowsArray.forEach {
            let rowNodeViews = $0.filter { $0.nodeView != nil }
            if !rowNodeViews.isEmpty {
                let intsArray = createArrayOfIntsForSorting(array: $0)
                let sortedIntsArray = sort(array: intsArray)
                let sortedGridDatasArray = createGridDatasArray(initialArray: $0, intsArray: sortedIntsArray)
                setSortedGridDatasArray(sortedArray: sortedGridDatasArray)
            }
        }

        redrawScreen()
    }
    
    private func redrawScreen() {
        removeAllNodeSubviews()
        drawGrid()
        putNodeOnAFreeField()
    }
    
    private func createArrayOfIntsForSorting(array: [GridData]) -> [UInt] {
        var intsArray = [UInt]()
        for gridData in array {
            guard let nodeView = gridData.nodeView else {
                continue
            }
            
            intsArray.append(nodeView.value)
        }
        
        return intsArray
    }
    
    private func createGridDatasArray(initialArray: [GridData], intsArray: [MoveData]) -> [AnimatedGridData] {
        var gridDatasArray = [AnimatedGridData]()
        for (index, gridData) in initialArray.enumerated() {
            if index < intsArray.count {
                let nodeView = NodeView(index: gridData.index,
                                        frame: gridData.frame,
                                        value: intsArray[index].value)
                let newGridData: GridData = (index: gridData.index,
                                            frame: gridData.frame,
                                            nodeView: nodeView)
                gridDatasArray.append((newGridData, intsArray[index].animationType))
            } else {
                let newGridData: GridData = (index: gridData.index,
                                            frame: gridData.frame,
                                            nodeView: nil)
                gridDatasArray.append((newGridData, nil))
            }
        }
        
        return gridDatasArray
    }
    
    private func setSortedGridDatasArray(sortedArray: [AnimatedGridData]) {
        for animatedGridData in sortedArray {
            if let nodeView = animatedGridData.gridData.nodeView {
                gridDatasArrays[animatedGridData.gridData.index.x][animatedGridData.gridData.index.y].nodeView = nodeView
                if let animationType = animatedGridData.animationType {
                    switch animationType {
                    case .merge:
                        nodeView.animateMerge()
                    default:
                        print(animationType)
                    }
                }
            } else {
                gridDatasArrays[animatedGridData.gridData.index.x][animatedGridData.gridData.index.y].nodeView = nil
            }
        }
    }
    
    private func sort(array: [UInt]) -> [MoveData] {
        var sortedGridArray = [MoveData]()
        var makeBreakAfterMerge = false
        
        for (currentIndex, currentItem) in array.enumerated() {
            if makeBreakAfterMerge == false {
                let lastIndex = array.count - 1
                if currentIndex < lastIndex {
                    let nextIndex = currentIndex + 1
                    let nextItem = array[nextIndex]
                    if currentItem != 0 {
                        if currentItem != nextItem {
                            sortedGridArray.append((currentItem, nil))
                        } else if currentItem == nextItem {
                            let newItem = currentItem + nextItem
                            sortedGridArray.append((newItem, .merge))
                            makeBreakAfterMerge = true
                            
                            delegate?.addToScore(value: newItem)
                        }
                    }
                } else if currentIndex == lastIndex, currentItem != 0 {
                    sortedGridArray.append((currentItem, nil))
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
    func setupGridView(height: CGFloat, gridCount: Int) {
        self.height = height
        self.gridCount = gridCount
        
        var initialMatrix = [[Index]]()
        for verticalIndex in 0..<gridCount {
            var verticalArray = [Index]()
            for horizontalIndex in 0..<gridCount {
                verticalArray.append((verticalIndex, horizontalIndex))
            }
            initialMatrix.append(verticalArray)
        }
        
        let unitsCount = (gridCount * 6) + (gridCount + 1)
        let verticalInset = CGFloat(height / CGFloat(unitsCount))
        let horizontalInset = CGFloat(height / CGFloat(unitsCount))
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
                nodeSuperview.backgroundColor = UIColor.init(named: "gameContainerBackground")
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
    
    private func cleanupGridDatasArray() {
        gridDatasArrays = [[GridData]]()
    }
    
    private func putNodeOnAFreeField() {
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
            nodeView.animateAppearance()
        } catch {
            delegate?.didThrow(error: error)
        }
    }
}
