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
        let image: UIImage
        let text: String
        let emojiID: Int?
        let soundPath: String?
    }
    
    @IBOutlet weak var photoImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var inputTextFieldMinimumHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollersContainer: UIStackView!
    @IBOutlet var emojiView: [UIButton]!
    @IBOutlet var soundButtons: [UIButton]!
    
    lazy var timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (_) in
        self.photoImgView.image = IMAGE
    }
    
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
        
        _ = timer
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        
        scrollersContainer.isHidden = true
        
        inputTextView.text = "Message"
        inputTextView.textColor = UIColor.lightGray
        
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        for (index, button) in emojiView.enumerated() {
            button.layer.cornerRadius = 22.5
            button.tag = (index)
        }
        
        for (index, button) in soundButtons.enumerated() {
            button.layer.cornerRadius = 4
            button.tag = (index)
        }
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
    
    let networkingService = NetworkingService()
    
    var music = [MusicEntity]()
    
    @IBAction func send() {
        if case State.attachmentsConfuration(let text) = self.state {

            let bytes = IMAGE!.jpegData(compressionQuality: 0.2)!.base64EncodedString()
            
            print("Got bytes")
            networkingService.performRequest(to: EndpointCollection.photo, with: PhotoRequest(emotion: selectedEmojiID ?? 6, photo: bytes)) { (result: Result<PhotoResponse>) in
                print("Got response")
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        guard let link = response.links.last else {
                            let alert = UIAlertController(title: "Erroe", message: "Retake photo please", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        URLSession.shared.dataTask(with: URL(string: link)!, completionHandler: { (data, _, error) in
                            DispatchQueue.main.async {
                                guard error == nil else {
                                    return
                                }
                                
                                if let data = data {
                                    let image = UIImage(data: data)!
                                    // Send msg with 'selectedSoundPath'
                                    self.messages.insert(ViewController.Message(image: image, text: text, emojiID: self.selectedEmojiID, soundPath: self.selectedSoundPath), at: 0)
                                    if let path = self.selectedSoundPath {
                                        self.playerService.play(path)
                                    }
                                    
                                    self.inputTextView.text = ""
                                    self.state = .textEntering
                                    self.selectedSoundPath = nil
                                    self.scrollersContainer.isHidden = true
                                }
                            }
                        }).resume()
                        
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            return
        }
        
        networkingService.performRequest(to: EndpointCollection.emotion(text: inputTextView.text)) { (result: Result<EmotionResponse>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.state = .attachmentsConfuration(text: self.inputTextView.text)
                    self.selectedEmojiID = response.emotion
                    self.setSelectedEmoji(for: response.emotion - 1)
                    self.scrollersContainer.isHidden = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
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
                    self.state = .attachmentsConfuration(text: self.inputTextView.text)
                    self.selectedSoundPath = nil
                    self.setSelectedSound(for: 0)
                    self.scrollersContainer.isHidden = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    var selectedSoundPath: String?
    var selectedEmojiID: Int?
    
    @IBAction func setEmoji(_ sender: UIButton) {
        self.setSelectedEmoji(for: sender.tag)
        self.selectedEmojiID = sender.tag + 1
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
        
        let emojiID = (message.emojiID ?? 6) - 1
        
        cell.emoji = emojiView?[emojiID].titleLabel?.text
        
        cell.indexPath = indexPath
        cell.delegate = self
        cell.messageLabel.text = message.text
        cell.userImageView.image = message.image
        
        cell.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! Cell
        
        cell.startEmiting()
        
        UIView.animate(withDuration:1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseInOut],
                       animations: {
            cell.userImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: {
            (value: Bool) in
            UIView.animate(withDuration: 0.2, animations: {
                cell.userImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
        
        
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
        if playerService.isPlaying {
            playerService.stop()
        } else {
            guard let path = messages[indexPath.row].soundPath else { return }
            playerService.play(path)
        }
    }
    
}
