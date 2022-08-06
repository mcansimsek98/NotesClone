//
//  NotesModel.swift
//  Notes
//
//  Created by Mehmet Can Şimşek on 5.08.2022.
//

import UIKit


class Notes: NSObject, Codable {
    
    var noteText: String
    var id = UUID()
    
    init(noteText: String) {
        self.noteText = noteText
        id = UUID()
    }
    
}
