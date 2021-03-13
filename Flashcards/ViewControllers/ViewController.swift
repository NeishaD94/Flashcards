//
//  ViewController.swift
//  Flashcards
//
//  Created by Lyneisha Dickenson on 2/20/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    var flashcardController: ViewController!
    
    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = true;
    }
    
    func updateFlashcard(question: String, answer: String) {
        frontLabel.text = question
        backLabel.text = answer
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {

      let navigationController = segue.destination as! UINavigationController
        //print(String(describing:navigationController.topViewController.self))

      let creationController = navigationController.topViewController as! CreationViewController

      creationController.flashcardsController = self
  }
}



