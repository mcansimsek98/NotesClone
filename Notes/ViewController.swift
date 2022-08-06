//
//  ViewController.swift
//  Notes
//
//  Created by Mehmet Can Şimşek on 5.08.2022.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var CountLbl: UILabel!
    
    var notesArray = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        title = "Notes"
        getData()
    
        print(notesArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        CountLbl.text = "\(notesArray.count) Notes"
        tableView.reloadData()
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
        CountLbl.text = "\(notesArray.count) Notes"
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CellVC else {
            fatalError("Cell error")
        }
        let note = notesArray[indexPath.row]
        cell.titleLbl.text = note.noteText
        
        cell.subtitleLbl.text = "          "
        return cell
        
    }
    
    
    @IBAction func newNotesBtn(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Notes") as? NotesVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notesArray[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsNotes") as? DetailsViewController {
            vc.selectedText = note.noteText
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          
         notesArray.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade)
          
          let defaults = UserDefaults.standard
          defaults.removeObject(forKey: "Notes")
          defaults.synchronize()
          
          let jsonEncoder = JSONEncoder()
           if let saveData = try? jsonEncoder.encode(notesArray) {
               let defaults = UserDefaults.standard
               defaults.set(saveData, forKey: "Notes")
           }else {
               print("Failed to save notes.")
           }
  
        CountLbl.text = "\(notesArray.count) Notes"

      }
       
    }
    
    
    
    
    
}

