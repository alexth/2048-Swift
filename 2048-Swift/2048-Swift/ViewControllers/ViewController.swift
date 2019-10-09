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
    @IBOutlet weak var gridView: GridView!
    
    private lazy var score: UInt = 0
    private lazy var bestScore: UInt = {
        return UserDefaultsManager.fetchBest
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.delegate = self
        fetchAndDisplayBestScore()
        setupGestures()
        roundViewsCorners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gridView.setupGridView(height: gridView.frame.width)
        gridView.startGame()
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    
    @objc private func swipeMade(_ gestureRecognizer: UISwipeGestureRecognizer) {
        gridView.didPerform(move: gestureRecognizer.direction)
    }
    
    private func startNewGame() {
        score = 0
        scoreValueLabel.text = "\(score)"
        gridView.removeAllNodeSubviews()
        gridView.startGame()
    }
    
    // MARK: - Setup
    
    private func fetchAndDisplayBestScore() {
        bestValueLabel.text = "\(bestScore)"
    }
    
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
    
    // MARK: - Utils
    
    private func roundViewsCorners() {
        scoreView.roundCorners()
        bestView.roundCorners()
    }
}

extension ViewController: GridViewDelegate {
    func addToScore(value: UInt) {
        score += value
        scoreValueLabel.text = "\(score)"
        if score > bestScore {
            bestValueLabel.text = "\(score)"
            UserDefaultsManager.store(best: score)
        }
    }
    
    func didThrow(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "New Game",
                                     style: .default,
                                     handler: { _ in
                                        self.startNewGame()
        })
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
