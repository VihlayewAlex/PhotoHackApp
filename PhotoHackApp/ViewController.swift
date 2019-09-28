//
//  ViewController.swift
//  PhotoHackApp
//
//  Created by Alex on 9/28/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum State {
        case textEntering
        case attachmentsConfuration(text: String)
    }
    
    struct Message {
        let text: String
        let emojiID: Int?
        let soundPath: String?
        var isPlayed: Bool
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var inputTextFieldMinimumHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollersContainer: UIStackView!
    @IBOutlet var emojiView: [UIButton]!
    @IBOutlet var soundButtons: [UIButton]!
    
    let camera = Camera()
    let playerService = SoundPlayerService()
    
    fileprivate var selectedTag = 0
    
    var state: State = .textEntering
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var messages = [Message]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        
        scrollersContainer.isHidden = true
        
        inputTextView.text = "Message"
        inputTextView.textColor = UIColor.lightGray
        
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        for (index, button) in emojiView.enumerated() {
            button.layer.cornerRadius = 22.5
            button.tag = index
        }
        
        for (index, button) in soundButtons.enumerated() {
            button.layer.cornerRadius = 4
            button.tag = index
        }
//        camera.setupCamera()
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
    
    let networkingService = NetworkingService()
    
    var music = [MusicEntity]()
    
    @IBAction func send() {
        if case State.attachmentsConfuration(let text) = self.state {
            // Send msg with 'selectedSoundPath'
            print("""
                MSG: \(text)
                SOUND: \(selectedSoundPath)
                EMOJI: \(selectedEmojiID)
            """)
            messages.insert(ViewController.Message(text: text, emojiID: selectedEmojiID, soundPath: selectedSoundPath, isPlayed: false), at: 0)
            //
            
            inputTextView.text = ""
            state = .textEntering
            selectedSoundPath = nil
            scrollersContainer.isHidden = true
            return
        }
        
        networkingService.performRequest(to: EndpointCollection.music(phrase: inputTextView.text, words: ["dick"])) { (result: Result<MusicResponse>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.music = response
                    for (index, button) in self.soundButtons.enumerated() {
                        guard index != 0 else {
                            button.setTitle("  No music  ", for: .normal)
                            button.isHidden = false
                            continue
                        }
                        guard self.music.count > (index - 1) else {
                            button.isHidden = true
                            continue
                        }
                        button.isHidden = false
                        button.setTitle("  " + self.music[index - 1].title + "  ", for: .normal)
                    }
                    self.scrollersContainer.isHidden = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
//        print("IMAGE:", IMAGE)
        
//        messages.append(inputTextView.text)
//        inputTextView.text = ""

//        playerService.play("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
//        messages.append(inputTextView.text)
//        inputTextView.text = ""
    }
    
    var selectedSoundPath: String?
    var selectedEmojiID: Int?
    
    @IBAction func setEmoji(_ sender: UIButton) {
        self.setSelectedEmoji(for: sender.tag)
        self.selectedEmojiID = sender.tag
        self.state = .attachmentsConfuration(text: inputTextView.text)
    }
    
    @IBAction func setSound(_ sender: UIButton) {
        self.setSelectedSound(for: sender.tag)
        if sender.tag > 0 {
            self.selectedSoundPath = music[sender.tag - 1].preview
        } else {
            self.selectedSoundPath = nil
        }
        self.state = .attachmentsConfuration(text: inputTextView.text)
    }
    
    func setSelectedSound(for tag: Int) {
        self.soundButtons.forEach { (button) in
            if button.tag == tag {
                self.selectedTag = tag
                button.backgroundColor = UIColor(displayP3Red: 0.577, green: 0.289, blue: 0.867, alpha: 1)
            } else {
                button.backgroundColor = UIColor(displayP3Red: 0.329, green: 0.324, blue: 0.478, alpha: 1)
            }
        }
    }

    
    func setSelectedEmoji(for tag: Int) {
        self.emojiView.forEach { (button) in
            if button.tag == tag {
                self.selectedTag = tag
                button.backgroundColor = UIColor(displayP3Red: 0.577, green: 0.289, blue: 0.867, alpha: 1)
            } else {
                button.backgroundColor = UIColor(displayP3Red: 0.329, green: 0.324, blue: 0.478, alpha: 1)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        let message = messages[indexPath.row]
        
        cell.indexPath = indexPath
        cell.delegate = self
        cell.messageLabel.text = message.text
//        cell.
        
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

extension ViewController: CellDelegate {
    
    func playTapped(at indexPath: IndexPath) {
        
        if !self.messages[indexPath.row].isPlayed {
            playerService.play(self.messages[indexPath.row].soundPath ?? "")
            let cell = self.tableView.cellForRow(at: indexPath) as! Cell
            cell.playButton.setTitle("Stop", for: .normal)
            self.messages[indexPath.row].isPlayed = true
        }else {
            playerService.stop()
            let cell = self.tableView.cellForRow(at: indexPath) as! Cell
            cell.playButton.setTitle("Play", for: .normal)
            self.messages[indexPath.row].isPlayed = false
        }
    }
    
}
