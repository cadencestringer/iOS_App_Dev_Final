//
//  DrawingViewController.swift
//  DrawingApp
//
//  Created by Cady Stringer on 12/5/20.
//
import UIKit
import PencilKit

class DrawingViewController: UIViewController {
    
    //creates the canvas view to be used for drawing
    lazy var canvas: PKCanvasView = {
        let v = PKCanvasView()
        //allows finger AND apple pencil drawing
        v.drawingPolicy = .anyInput
        v.minimumZoomScale = 1
        v.maximumZoomScale = 2
        //allows us to set our own constraints instead of automatic ones
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //gives us all the different pencil/pen options
    lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(self)
        return toolPicker
    }()
    
    //creates a photo view
    lazy var photoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //empty initially
    var drawingData = Data()
    //call this whenever the drawing changes
    var drawingChanged: (Data) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvas)
        
        //setting our constraints manually
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        //canvas setup
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.delegate = self
        canvas.becomeFirstResponder()
        
        //save button:
        let saveButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        //manually set location
        saveButton.frame = CGRect(x:CGFloat(352),y:CGFloat(5),
                              width:CGFloat(55),height:CGFloat(35))
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.layer.cornerRadius = 5
        saveButton.setTitle("Save", for: UIControl.State.normal)
        saveButton.tintColor = UIColor.white
        saveButton.addTarget(self, action: #selector(DrawingViewController.saveButtonPressed(_:)), for: .touchUpInside)
        saveButton.clipsToBounds = true
        self.view.addSubview(saveButton)
        
        //Share button
        let shareButton = UIButton(type: UIButton.ButtonType.system) as UIButton

        shareButton.frame = CGRect(x:CGFloat(352),y:CGFloat(45),
                              width:CGFloat(55),height:CGFloat(35))
        shareButton.backgroundColor = UIColor.systemBlue
        shareButton.layer.cornerRadius = 5
        shareButton.setTitle("Share", for: UIControl.State.normal)
        shareButton.tintColor = UIColor.white
        shareButton.addTarget(self, action: #selector(DrawingViewController.shareButtonPressed(_:)), for: .touchUpInside)
        shareButton.clipsToBounds = true
        self.view.addSubview(shareButton)
        
        if let drawing = try? PKDrawing(data: drawingData){
            canvas.drawing = drawing
        }
    }

    @objc func saveButtonPressed(_ sender:UIButton!){
        saveImage()
    }
    
    @objc func shareButtonPressed(_ sender:UIButton!){
        shareImage()
    }
    
    //from medium article:
    @objc func saveImage() {
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1.0)
        UIImageWriteToSavedPhotosAlbum(image,self,nil,nil)
    }
    
    //allows user to share their image via imessage with the caption: "Check out my drawing!"
    @objc func shareImage() {
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1.0)
        let items: [Any] = ["Check out my drawing!", image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
//    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType: UIActivity.ActivityType?) -> Any? {
//        if itemForActivityType == .postToTwitter {
//            return "Check out my #MyAwesomeApp via @twostraws."
//        } else {
//            return "Download MyAwesomeApp from TwoStraws."
//        }
//    }

}

//MARK:- PK Delegates
extension DrawingViewController: PKToolPickerObserver, PKCanvasViewDelegate{
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        //converts canvas drawing into data presentation and pass it back wherever we implement the closure call
        drawingChanged(canvasView.drawing.dataRepresentation())
    }
}
