//
//  ViewController.swift
//  Flashcards
//
//  Created by Lyneisha Dickenson on 2/20/21.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    
    
    var flashcardController: ViewController!
    
    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var card: UIView!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typicall from a nib.
        
        //Read saved flashcards
        readSavedFlashcards()
        
        //Adding our inital flashcard if needed
        if flashcards.count == 0 {
            updateFlashcard(question: "When is my Birthday?", answer: "December 24th")
        } else  {
            updateLabels()
            updateNextPrevButtons()
        }
        
         card.layer.cornerRadius = 20.0
         frontLabel.layer.cornerRadius = 20.0
         frontLabel.clipsToBounds = true
         backLabel.layer.cornerRadius = 20.0
         backLabel.clipsToBounds = true
         card.layer.shadowRadius = 15.0
         card.layer.shadowOpacity = 0.2
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           // First start with the flashcard invisible and slightly smaller in size
           card.alpha = 0.0
           card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
         
           // Animation
           UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
               self.card.alpha = 1.0
               self.card.transform = CGAffineTransform.identity
              
           })
       }
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        //Increase current index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
        
        // Animation
        animateCardOut(animationDirection: "moveEverythingRight")
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        //Increase current index
        currentIndex = currentIndex + 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
        
        // Animation
        animateCardOut(animationDirection: "moveEverythingLeft")
    }
    func animateCardOut(animationDirection: String) {
         UIView.animate(withDuration: 0.3, animations: {
             if animationDirection == "moveEverythingLeft"{
                 // Move the card to the left by changing the x coordinates
                 self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
             }else{
                 // Move the card to the right
                 self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
             }
             
         }, completion: { finished in
             // Update labels
             self.updateLabels()
             
             // Run other animation
             if animationDirection == "moveEverythingLeft"{
                 self.animateCardIn(startingPosition: 300.0)
             }else{
                 self.animateCardIn(startingPosition: -300.0)
             }
             
         })
     }
     
     func animateCardIn(startingPosition: CGFloat){
         // This will move the card to the center. start the card offscreen so its not visible then move to center
         card.transform = CGAffineTransform.identity.translatedBy(x: startingPosition, y: 0.0)
         
         // Animate card going back to its original position
         UIView.animate(withDuration: 0.3) {
             self.card.transform = CGAffineTransform.identity
         }
     }
    
    func updateLabels() {
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    

     
        
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: { self.frontLabel.isHidden = true
        })
        
    }
      
        
    
    
    func saveAllFlashcardsToDisk() {
        
        //From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer":card.answer]
        }
        
        //Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //Log it
        print("Flashcards saved to UserDefaults")
    }
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
        
        //Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcads")
        
        // Update current index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        // Update buttons
        updateNextPrevButtons()
        
        //Update labels
        updateLabels()
        
        //Call flashcards everytime array cahnges
        saveAllFlashcardsToDisk()
    }
    
    //read perivously saved flashacards
    func readSavedFlashcards() {
        
        //Read ddictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            //In here we know for sure we have a dictionary
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    func updateNextPrevButtons() {
        
        //Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }


    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {

      let navigationController = segue.destination as! UINavigationController
        //print(String(describing:navigationController.topViewController.self))

      let creationController = navigationController.topViewController as! CreationViewController

      creationController.flashcardsController = self
  }
}



