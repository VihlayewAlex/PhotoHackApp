//
//  ViewController.swift
//  PhotoHackApp
//
//  Created by Alex on 9/28/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var inputTextFieldMinimumHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputContainerViewBottomConstraint: NSLayoutConstraint!
    
    let camera = Camera()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextView.text = "Message"
        inputTextView.textColor = UIColor.lightGray
        
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        camera.setupCamera()
        subscribeToKeyboardEvents()
    }
    
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] (notification) in
            if let keyboardFrameRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self?.inputContainerViewBottomConstraint.constant = (UIScreen.main.bounds.height - keyboardFrameRect.origin.y)
                self?.view.layoutSubviews()
            }
        }
    }
    
    @IBAction func send() {
        print("TEXT:", inputTextView.text)
        print("IMAGE:", IMAGE)
        
        messages.append(inputTextView.text)
        inputTextView.text = ""
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        cell
        
        cell.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        return cell
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = !textView.text.isEmpty
        
        inputTextFieldMinimumHeightConstraint.constant = (textView.contentSize.height > 188) ? 188 : 38
        textView.isScrollEnabled = (textView.contentSize.height > 188)
        textView.invalidateIntrinsicContentSize()
        view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
