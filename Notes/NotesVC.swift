//
//  NotesVC.swift
//  Notes
//
//  Created by Mehmet Can Şimşek on 5.08.2022.
//

import UIKit

class NotesVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var textView: UITextView!
    
    var notesArray = [Notes]()
        
    var selectedTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
     
      let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "Notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notesArray = try jsonDecoder.decode([Notes].self, from: savedNotes)
            } catch {
                print("Failed to load notes")
            }
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
 

    }


    @objc func done() {
        if textView.text == "" {
            textView.text = "New Notes"
        }

        let note = Notes(noteText: textView.text)
        notesArray.append(note)
        save()
        self.navigationController?.popViewController(animated: true)
        //alert()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
         if let saveData = try? jsonEncoder.encode(notesArray) {
             let defaults = UserDefaults.standard
             defaults.set(saveData, forKey: "Notes")
             
         }else {
             print("Failed to save notes.")
         }
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
}
