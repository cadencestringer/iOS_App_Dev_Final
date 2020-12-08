//
//  ContentView.swift
//  DrawingApp
//
//  Created by Cady Stringer on 12/5/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = DrawingManager()
    @State private var addNewShown = false

    var body: some View {
        NavigationView {
            List {
                ForEach(manager.docs) { doc in NavigationLink(destination: DrawingWrapper(manager: manager, id: doc.id),
                    label: { Text(doc.name) })
                }.onDelete(perform: manager.delete)
            }.navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Add"){
                self.addNewShown.toggle()
            })

            .sheet(isPresented: $addNewShown, content: {
                AddNewDocument(manager: manager, addShown: $addNewShown)
            })
            
        }
        
    }
}
