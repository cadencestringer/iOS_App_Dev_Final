//
//  AddNewDocument.swift
//  DrawingApp
//
//  Created by Cady Stringer on 12/5/20.
//

import SwiftUI

struct AddNewDocument: View {
    @ObservedObject var manager: DrawingManager
    @State private var documentName: String = ""
    @Binding var addShown: Bool
    
    var body: some View{
        VStack {
            Text("Enter drawing name:" )
            //allows us to save data when the user hits enter from textfield
            TextField("Enter drawing name HERE...", text: $documentName,
                      onCommit: {
                        save(fileName: documentName)
                      })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            //saves the user's drawing name when they click "create"
            Button("Create") {
                save(fileName: documentName)
            }
        }.padding()
    }
    
    //adds the drawing information to the core data 
    private func save(fileName: String){
        manager.addData(doc: DrawingDocument(id: UUID(), data: Data(), name: fileName))
        addShown.toggle()
    }
}
