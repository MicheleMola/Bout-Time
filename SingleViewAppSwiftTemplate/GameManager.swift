//
//  GameManager.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 24/04/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import GameKit

class GameManager {
  var events: [Event]
  var arrayOfRandomIndexes: [Int] = [Int]()
  let numberOfEventsPerRound = 4
  var currentRound = 0
  let numberOfRounds = 6
  var correctSequence = 0
  
  // Create two object of the SoundManager class (One to manage the sound on correct answer and the other to manage the sound on wrong answer)
  let correctSound = SoundManager(fileName: "CorrectDing", fileType: "wav", idSound: 0)
  let wrongSound = SoundManager(fileName: "IncorrectBuzz", fileType: "wav", idSound: 1)
  
  init(events: [Event]) {
    self.events = events
    
    loadSound()
  }
  
  func loadSound() {
    do {
      try correctSound.load()
      try wrongSound.load()
    } catch {
      print(error)
    }
  }
  
  func getRandomEvents() -> [Event] {
    var events: [Event] = [Event]()
    
    for _ in 0..<numberOfEventsPerRound {
      let randomIndex = generateRandomIndex()
      events.append(self.events[randomIndex])
    }
    
    // Increment number of round
    currentRound += 1
    
    // Return a events collection of four elements (numberOfEventsPerRound)
    return events
  }
  
  func generateRandomIndex() -> Int {
    // Generate random number between 0 and events.count -1
    var indexRandom = GKRandomSource.sharedRandom().nextInt(upperBound: self.events.count)
    
    // Loop until the generated random index is not present in arrayOfRandomIndexes
    while self.arrayOfRandomIndexes.contains(indexRandom) {
      
      // Generate a new random index
      indexRandom = GKRandomSource.sharedRandom().nextInt(upperBound: self.events.count)
    }
    
    // Add new random index to array
    self.arrayOfRandomIndexes.append(indexRandom)
    
    // Return a random index
    return indexRandom
  }
  
  func isGameOver() -> Bool {
    
    // Check if the round is over
    return self.currentRound == self.numberOfRounds ? true : false
  }
  
  func resetRound() {
    // Clear array of random indexes
    self.arrayOfRandomIndexes = []
  }
  
  func isCorrectSequence(events: [Event]) -> Bool {
    
    resetRound()
    
    if isSorted(events: events) {
      self.correctSequence += 1
      correctSound.play()
      return true
    }
    
    wrongSound.play()
    return false
  }
  
  func isSorted(events: [Event]) -> Bool {
    
    // Check if the events collection is ordered increasingly
    for i in 1..<events.count {
      if events[i - 1].year > events[i].year {
        return false
      }
    }
    return true
  }
  
  func resetGame() {
    self.currentRound = 0
    self.correctSequence = 0
  }
  
  func feedbackGame() -> String {
    
    // Return feedback
    return "\(correctSequence)/\(numberOfRounds)"
  }
}
