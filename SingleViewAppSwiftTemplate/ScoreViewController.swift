//
//  ScoreViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 27/04/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
  
  @IBOutlet weak var scoreLabel: UILabel!
  
  // Score string passed by View Controller
  var score: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let score = score {
      scoreLabel.text = score
    }
  }

}
