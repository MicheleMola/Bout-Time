//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var firstView: UIView!
  @IBOutlet weak var secondView: UIView!
  @IBOutlet weak var thirdView: UIView!
  @IBOutlet weak var fourthView: UIView!
  
  @IBOutlet weak var nextRound: UIButton!
  
  @IBOutlet weak var countdown: UILabel!
  
  let gameManager: GameManager
  
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
    
    setupView()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupView() {
    firstView.layer.cornerRadius = 5.0
    secondView.layer.cornerRadius = 5.0
    thirdView.layer.cornerRadius = 5.0
    fourthView.layer.cornerRadius = 5.0
    
    nextRound.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
    nextRound.imageView?.contentMode = .scaleAspectFit
    
    //nextRound.isHidden = true
    
    countdown.isHidden = true
  }
  
  
}

