//
//  ViewController.swift
//  2048-Swift
//
//  Created by Alex Golub on 9/25/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var bestView: UIView!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var bestValueLabel: UILabel!
    @IBOutlet weak var matrixView: MatrixView!
//    @IBOutlet weak var gameView: UIView!
//    private var matrixView: MatrixView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
//        addMatrixViewToGameView()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        addMatrixViewToGameView()
//        super.viewWillAppear(animated)
//    }
    
    // MARK: - Actions
    
    private func leftMove() {
        print("left")
    }
    
    private func rightMove() {
        print("right")
    }
    
    private func upMove() {
        print("up")
    }
    
    private func downMove() {
        print("down")
    }
    
    // MARK: - Setup
    
    private func setupGestures() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
            #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
            #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        let upRecognizer = UISwipeGestureRecognizer(target: self, action:
            #selector(swipeMade(_:)))
        upRecognizer.direction = .up
        let downRecognizer = UISwipeGestureRecognizer(target: self, action:
            #selector(swipeMade(_:)))
        downRecognizer.direction = .down
        
        view.addGestureRecognizer(leftRecognizer)
        view.addGestureRecognizer(rightRecognizer)
        view.addGestureRecognizer(upRecognizer)
        view.addGestureRecognizer(downRecognizer)
    }
    
    @objc private func swipeMade(_ gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
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
    
//    private func addMatrixViewToGameView() {
//        matrixView = MatrixView(frame: gameView.bounds)
//        matrixView.backgroundColor = .green
//        
//        gameView.addSubview(matrixView)
//    }
}
