//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

enum Direction {
  case up
  case down
}

class ViewController: UIViewController {
  
  @IBOutlet weak var firstView: UIView!
  @IBOutlet weak var secondView: UIView!
  @IBOutlet weak var thirdView: UIView!
  @IBOutlet weak var fourthView: UIView!
  
  @IBOutlet weak var firstButton: UIButton!
  @IBOutlet weak var secondButton: UIButton!
  @IBOutlet weak var thirdButton: UIButton!
  @IBOutlet weak var fourthButton: UIButton!
  
  @IBOutlet weak var nextRoundButton: UIButton!
  
  @IBOutlet weak var countdown: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  
  
  // Set of variables for the timer
  var timerIsOn = false
  var timer = Timer()
  var timeRemaining = 60
  let totalTime = 60
  
  let gameManager: GameManager
  var events = [Event]()
  var buttonsCollection = [UIButton]()
  
  required init?(coder aDecoder: NSCoder) {
    do {
      let data = try PlistConverter.data(fromFile: "Events", ofType: "plist")
      let events = try EventsUnarchiver.parseEvents(fromData: data)
      self.gameManager = GameManager(events: events)
    } catch let error {
      fatalError("\(error)")
    }
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    buttonsCollection = [firstButton, secondButton, thirdButton, fourthButton]
    
    roundView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    displayEvents()
  }
  
  override func becomeFirstResponder() -> Bool {
    return true
  }
  
  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      checkSequence()
    }
  }
  
  func displayEvents() {
    // Start timer
    startTimer()
    
    countdown.isHidden = false
    nextRoundButton.isHidden = true
    infoLabel.text = "Shake to complete"
        
    self.events = gameManager.getRandomEvents()
    
    updateEventsPosition()
  }
  
  func updateEventsPosition() {
    
    for (event, button) in zip(events, buttonsCollection) {
      button.setTitle(event.text, for: .normal)
    }
  }
  
  func roundView() {
    firstView.layer.cornerRadius = 5.0
    secondView.layer.cornerRadius = 5.0
    thirdView.layer.cornerRadius = 5.0
    fourthView.layer.cornerRadius = 5.0
    
  }
  
  @IBAction func downButtonPressed(_ sender: UIButton) {
    swapEvent(withIndex: sender.tag, andDirection: .down)
  }
  
  @IBAction func upButtonPressed(_ sender: UIButton) {
    swapEvent(withIndex: sender.tag, andDirection: .up)
  }
  
  @IBAction func nextRoundPressed(_ sender: UIButton) {
    nextRound()
  }
  
  
  func swapEvent(withIndex index: Int, andDirection direction: Direction) {
    switch direction {
    case .down:
      self.events.swapAt(index + 1, index)
    case .up:
      self.events.swapAt(index - 1, index)
    }
    
    updateEventsPosition()
  }
  
  func nextRound() {
    
    // Check if the game is over
    if self.gameManager.isGameOver() {
      
      // Game is over and show the score
      goToScoreView()
      
    } else {
      // Continue game
      
      // Show a new question
      displayEvents()
    }
  }
  
  func goToScoreView() {
    let score = self.gameManager.feedbackGame()
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    if let vc : ScoreViewController = mainStoryboard.instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController {
      vc.score = score
      self.present(vc, animated: true, completion: nil)
    }
    
    self.gameManager.resetGame()
    
  }
  
  func checkSequence() {
    
    stopTimer()
    
    let isCorrect = self.gameManager.isCorrectSequence(events: self.events)
    
    if isCorrect {
      nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
    } else {
      nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: .normal)
    }
    
    nextRoundButton.imageView?.contentMode = .scaleAspectFit
    nextRoundButton.isHidden = false
    
    countdown.isHidden = true
    infoLabel.text = "Tap events to learn more"
    
  }
  
  // MARK: Helper Methods
  
  func startTimer() {
    
    // Check if the timer isn't On
    if !timerIsOn {
      
      // Reset time remaining for the new question
      timeRemaining = 60
      
      // Schedule the timerRunning function one time per second
      timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
      
      // Set timerIsOn to true
      timerIsOn = true
    }
  }
  
  func stopTimer() {
    
    // Check if the timer is On
    if timerIsOn {
      
      // Stops the timer
      timer.invalidate()
      
      // Set timerIsOn to false
      timerIsOn = false
    }
  }
  
  @objc func timerRunning() {
    
    // Check if the remaining time is greater or equal to zero
    if timeRemaining >= 0 {
            
      // Update countdown
      countdown.text = "0:\(timeRemaining)"
      
    } else {
      
      // Time out
      timeOut()
    }
    
    // Decrease the remaining time
    timeRemaining -= 1
  }
  
  func timeOut() {
    
    // Stops the timer
    timer.invalidate()
    
    // Set timerIsOn to false
    timerIsOn = false
    
    checkSequence()
  }
  
}

