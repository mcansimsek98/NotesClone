//
//  DetailsViewController.swift
//  Notes
//
//  Created by Mehmet Can Şimşek on 6.08.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    var notesArray = [Notes]()
    
    var selectedText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(alert))

        if selectedText == selectedText {
            textView.text = selectedText
        }
        getData()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        

    }

    
    
    @objc func getData() {
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "Notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notesArray = try jsonDecoder.decode([Notes].self, from: savedNotes)
                //self.tableView.reloadData()
            } catch {
                print("Failed to load notes")
            }
        }
    }

    @objc func done() {
        if textView.text == "" {
            textView.text = "New Notes"
        }

        let note = Notes(noteText: textView.text)
        notesArray.append(note)
        save()
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
    
    @objc func alert() {
        let ac = UIAlertController(title: "", message: "Do you want to save the changes again?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
            self.done()
        }))
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)

        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
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
