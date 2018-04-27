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
  
  init(events: [Event]) {
    self.events = events
  }
  
  func getRandomEvents() -> [Event] {
    var events: [Event] = [Event]()
    
    for _ in 0..<numberOfEventsPerRound {
      let randomIndex = generateRandomIndex()
      events.append(self.events[randomIndex])
    }
    
    currentRound += 1
    
    return events
  }
  
  func generateRandomIndex() -> Int {
    // Generate random number between 0 and questions.count -1
    var indexRandom = GKRandomSource.sharedRandom().nextInt(upperBound: self.events.count)
    
    // Loop until the generated random index is not present in arrayOfRandomIndexes
    while self.arrayOfRandomIndexes.contains(indexRandom) {
      
      // Generate a new random index
      indexRandom = GKRandomSource.sharedRandom().nextInt(upperBound: self.events.count)
    }
    
    // Add new random index to array
    self.arrayOfRandomIndexes.append(indexRandom)
    
    return indexRandom
  }
  
  func isGameOver() -> Bool {
    
    // Check if the round is over
    return self.currentRound == self.numberOfRounds ? true : false
  }
  
  func resetRound() {
    self.arrayOfRandomIndexes = []
  }
  
  func isCorrectSequence(events: [Event]) -> Bool {
    
    resetRound()
    
    if isSorted(events: events) {
      self.correctSequence += 1
      return true
    }
    
    return false
  }
  
  func isSorted(events: [Event]) -> Bool {
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
