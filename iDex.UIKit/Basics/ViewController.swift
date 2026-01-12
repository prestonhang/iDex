//
//  ViewController.swift
//  iDex
//
//  Created by Preston Hang on 12/22/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var SplashLabel: UILabel!
    @IBOutlet weak var SplashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        SplashLabel.textAlignment = .center
        
        greetUser("Preston")
    }
    
    func greetUser(_ name: String) {
        SplashLabel.text = "Hello, \(name)!"
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        greetUser("Preston")
        print("Button Tapped!")
        view.backgroundColor = .systemBlue
    }
}

