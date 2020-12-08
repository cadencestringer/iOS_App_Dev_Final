//
//  DrawingWrapper.swift
//  DrawingApp
//
//  Created by Cady Stringer on 12/5/20.
//

import SwiftUI

struct DrawingWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = DrawingViewController
    var manager: DrawingManager
    var id: UUID
    
    //how data on canvas is supplied back to drawing manager and eventually will be passed on to core data
    func makeUIViewController(context: Context) -> DrawingViewController {
        let viewController = DrawingViewController()
        viewController.drawingData = manager.getData(for: id)
        //update data at recieved ID
        viewController.drawingChanged = { data in
            manager.update(data: data, for: id)
        }
        return viewController
    }
    
    //updates the view controller from core data
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        uiViewController.drawingData = manager.getData(for: id)
    }
}
