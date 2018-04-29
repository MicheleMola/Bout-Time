//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import SafariServices

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
  
  // Button Tag = 0
  @IBOutlet weak var firstDownButton: UIButton!
  
  // Button Tag = 1
  @IBOutlet weak var secondUpButton: UIButton!
  @IBOutlet weak var secondDownButton: UIButton!
  
  // Button Tag = 2
  @IBOutlet weak var thirdUpButton: UIButton!
  @IBOutlet weak var thirdDownButton: UIButton!
  
  // Button Tag = 3
  @IBOutlet weak var fourthUpButton: UIButton!
  
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
  
  var upAndDownButtonsCollection = [UIButton]()
  var eventTextButtonsCollection = [UIButton]()
  var viewsCollection = [UIView]()
  
  var shakeIsAllowed = false
  
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
    
    upAndDownButtonsCollection = [firstDownButton, secondUpButton, secondDownButton, thirdUpButton, thirdDownButton, fourthUpButton]
    
    eventTextButtonsCollection = [firstButton, secondButton, thirdButton, fourthButton]
    
    viewsCollection = [firstView, secondView, thirdView, fourthView]
    
    roundView()
    
    displayEvents()

  }
  
  override func becomeFirstResponder() -> Bool {
    return true
  }
  
  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake && shakeIsAllowed {
      checkSequence()
    }
  }
  
  func displayEvents() {
    startTimer()
    
    // Enable Up and Down buttons
    disableAndEnableUpAndDownButtons()
    
    // Disable User interaction on all events
    disableAndEnableUserInteractionOnEventTextButtons()
    
    // Enable motion shake
    shakeIsAllowed = true
    
    // Show countdown
    countdown.isHidden = false
    
    // Hide Next Round button
    nextRoundButton.isHidden = true
    
    // Change text in info label
    infoLabel.text = "Shake to complete"
    
    // Get Four random events
    self.events = gameManager.getRandomEvents()
    
    // Populate text events
    updateEventsPosition()
  }
  
  func disableAndEnableUpAndDownButtons() {
    for button in upAndDownButtonsCollection {
      button.isEnabled = !button.isEnabled
    }
  }
  
  func disableAndEnableUserInteractionOnEventTextButtons() {
    for button in eventTextButtonsCollection {
      button.isUserInteractionEnabled = !button.isUserInteractionEnabled
    }
  }
  
  func updateEventsPosition() {
    
    // Set event text for each buttons
    for (event, button) in zip(events, eventTextButtonsCollection) {
      button.setTitle(event.text, for: .normal)
    }
  }
  
  func roundView() {
    // Round all views
    for view in viewsCollection {
      view.layer.cornerRadius = 5.0
    }
  }
  
  @IBAction func downButtonPressed(_ sender: UIButton) {
    // Use the tag of the down button to change the events position in the events collection
    swapEvent(withIndex: sender.tag, andDirection: .down)
  }
  
  @IBAction func upButtonPressed(_ sender: UIButton) {
    // Use the tag of the up button to change the events position in the events collection
    swapEvent(withIndex: sender.tag, andDirection: .up)
  }
  
  @IBAction func nextRoundPressed(_ sender: UIButton) {
    nextRound()
  }
  
  // Change position event in events collection by index
  func swapEvent(withIndex index: Int, andDirection direction: Direction) {
    switch direction {
    case .down:
      // Swap event with index + 1 and index in the events collection
      self.events.swapAt(index + 1, index)
    case .up:
      // Swap event with index - 1 and index in the events collection
      self.events.swapAt(index - 1, index)
    }
    
    // Re-populate text events in buttons
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
    
    // Get score
    let score = self.gameManager.feedbackGame()
    
    // Present ScoreViewControl to show the score
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    if let vc : ScoreViewController = mainStoryboard.instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController {
      vc.score = score
      self.present(vc, animated: true, completion: nil)
    }
    
    // Reset game
    self.gameManager.resetGame()
  }
  
  func checkSequence() {
    
    // Stop Timer
    stopTimer()
    
    // Disable Up and Down buttons
    disableAndEnableUpAndDownButtons()
    
    // Enable User interaction on all events
    disableAndEnableUserInteractionOnEventTextButtons()
    
    // Enable motion shake
    shakeIsAllowed = false
    
    // Check sequence of events
    let isCorrect = self.gameManager.isCorrectSequence(events: self.events)
    
    if isCorrect {
      nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
    } else {
      nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: .normal)
    }
    
    // Change content mode to the next round button
    nextRoundButton.imageView?.contentMode = .scaleAspectFit
    
    // Show Next round button
    nextRoundButton.isHidden = false
    
    // Hide Countdown label
    countdown.isHidden = true
    
    // Change text in info label
    infoLabel.text = "Tap events to learn more"
  }
  
  @IBAction func eventTextPressed(_ sender: UIButton) {
    // Get link from event clicked using the tag button
    let url = self.events[sender.tag].link
    
    // Open link
    open(url: url)
  }
  
  func open(url: String) {
    
    // Present SFSafariViewController to show a web page with related information
    if let url = URL(string: url) {
      let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
      // Change the colors of bar
      vc.preferredBarTintColor = UIColor(red: 242/255, green: 153/255, blue: 55/255, alpha: 1.0)
      vc.preferredControlTintColor = UIColor.white
      
      present(vc, animated: true)
    }
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
    
    // Check sequence of events
    checkSequence()
  }
}


