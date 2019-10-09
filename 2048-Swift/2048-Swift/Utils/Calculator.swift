//
//  Calculator.swift
//  2048-Swift
//
//  Created by Alex Golub on 10/9/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import UIKit

final class Calculator {
    static func calculateInitialIndexes(gridCount: Int, move: UISwipeGestureRecognizer.Direction) -> [[Index]] {
        var indexesArraysArray = [[Index]]()
        switch move {
        case .left:
            indexesArraysArray = Calculator.leftMove(gridCount: gridCount)
        case .right:
            indexesArraysArray = Calculator.rightMove(gridCount: gridCount)
        case .up:
            indexesArraysArray = Calculator.upMove(gridCount: gridCount)
        case .down:
            indexesArraysArray = Calculator.downMove(gridCount: gridCount)
        default:
            fatalError("ERROR! Should not happen")
        }
        
        return indexesArraysArray
    }
    
    private static func leftMove(gridCount: Int) -> [[Index]] {
        // example for four rows
        // (x, y)
        // [(0, 0), (1, 0), (2, 0), (3, 0)]
        // [(0, 1), (1, 1), (2, 1), (3, 1)]
        // [(0, 2), (1, 2), (2, 2), (3, 2)]
        // [(0, 3), (1, 3), (2, 3), (3, 3)]
        var rowsIndexesArray = [[Index]]()
        for index in 0..<gridCount {
            var indexesRowArray = [Index]()
            for nestedIndex in 0..<gridCount {
                indexesRowArray.append((nestedIndex, index))
            }
            rowsIndexesArray.append(indexesRowArray)
        }
        
        return rowsIndexesArray
    }
    
    private static func rightMove(gridCount: Int) -> [[Index]] {
        // example for four rows
        // (x, y)
        // [(3, 0), (2, 0), (1, 0), (0, 0)]
        // [(3, 1), (2, 1), (1, 1), (0, 1)]
        // [(3, 2), (2, 2), (1, 2), (0, 2)]
        // [(3, 3), (2, 3), (1, 3), (0, 3)]
        let maxIndex = gridCount - 1
        var rowsIndexesArray = [[Index]]()
        for index in 0..<gridCount {
            var indexesRowArray = [Index]()
            for nestedIndex in 0..<gridCount {
                let xIndex = maxIndex - nestedIndex
                indexesRowArray.append((xIndex, index))
            }
            
            rowsIndexesArray.append(indexesRowArray)
        }
        
        return rowsIndexesArray
    }
    
    private static func upMove(gridCount: Int) -> [[Index]] {
        // example for four rows
        // (x, y)
        // [(0, 0), (0, 1), (0, 2), (0, 3)]
        // [(1, 0), (1, 1), (1, 2), (1, 3)]
        // [(2, 0), (2, 1), (2, 2), (2, 3)]
        // [(3, 0), (3, 1), (3, 2), (3, 3)]
        var rowsIndexesArray = [[Index]]()
        for index in 0..<gridCount {
            var indexesRowArray = [Index]()
            for nestedIndex in 0..<gridCount {
                indexesRowArray.append((index, nestedIndex))
            }
            
            rowsIndexesArray.append(indexesRowArray)
        }
        
        return rowsIndexesArray
    }
    
    private static func downMove(gridCount: Int) -> [[Index]] {
        // example for four rows
        // (x, y)
        // [(0, 3), (0, 2), (0, 1), (0, 0)]
        // [(1, 3), (1, 2), (1, 1), (1, 0)]
        // [(2, 3), (2, 2), (2, 1), (2, 0)]
        // [(3, 3), (3, 2), (3, 1), (3, 0)]
        let maxIndex = gridCount - 1
        var rowsIndexesArray = [[Index]]()
        for index in 0..<gridCount {
            var indexesRowArray = [Index]()
            for nestedIndex in 0..<gridCount {
                let xIndex = maxIndex - nestedIndex
                indexesRowArray.append((index, xIndex))
            }
            
            rowsIndexesArray.append(indexesRowArray)
        }
        
        return rowsIndexesArray
    }
}
