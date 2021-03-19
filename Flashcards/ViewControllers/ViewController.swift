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
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        //Increase current index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        //Increase current index
        currentIndex = currentIndex + 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
    }
    
    func updateLabels() {
        //Get cureent flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
  
    
 
    
    
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = true;
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



