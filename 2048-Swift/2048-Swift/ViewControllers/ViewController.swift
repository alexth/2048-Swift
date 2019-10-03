//
//  ViewController.swift
//  2048-Swift
//
//  Created by Alex Golub on 9/25/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import UIKit

public enum GameError: String, Error {
    case gameOver = "Game Over"
}

final class ViewController: UIViewController {
    
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var bestView: UIView!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var bestValueLabel: UILabel!
    @IBOutlet weak var matrixView: GridView!
    @IBOutlet weak var matrixViewHeight: NSLayoutConstraint!
    
    private var score: UInt = 0

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matrixView.delegate = self
        setupGestures()
        roundViewsCorners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        matrixView.setupMatrixView(height: matrixViewHeight.constant)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        matrixView.startGame()
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    
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
        matrixView.didPerform(move: gestureRecognizer.direction)
    }
    
    // MARK: - Utils
    
    private func roundViewsCorners() {
        scoreView.roundCorners()
        bestView.roundCorners()
    }
}

extension ViewController: MatrixViewDelegate {
    func addToScore(value: UInt) {
        score += value
        scoreValueLabel.text = "\(score)"
    }
    
    func didThrow(error: Error) {
        // TODO:
        print(error)
    }
}
