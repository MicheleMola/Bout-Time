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
  
  var score: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let score = score {
      scoreLabel.text = score
    }
  }
  
  @IBAction func playAgainPressed(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

}
