//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Tiago Missão on 19/07/17.
//  Copyright © 2017 missao. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    // MARK: - Strings
    
    struct AppConstants {
        static let RecordingInProgress = "Recording in Progress"
        static let TapToRecord = "Tap to Record"
        static let RecordingFileName = "recordedVoice.wav"
        static let SegueIdentifier = "stopRecording"
    }
    
    // MARK: - Alerts
    
    enum Alerts : String {
        case AudioErrorTitle = "Error",
        AudioErrorMessage = "Recording was not successful",
        DismissAlert = "Dismiss"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(isRecording: false)
    }
    
    
    // MARK: - Custom Methods
    
    
    /// Configures the UIElements enabling/disabling them
    ///
    /// - Parameter isRecording: indicates if the audio is being recorded
    private func configureUI(isRecording: Bool) {
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
        recordingLabel.text = isRecording ? AppConstants.RecordingInProgress : AppConstants.TapToRecord
    }
    
    
    // MARK: - UIActions
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = AppConstants.RecordingFileName
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.SegueIdentifier {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert.rawValue, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - AVAudioRecorderDelegate
extension RecordSoundsViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: AppConstants.SegueIdentifier, sender: audioRecorder.url)
            
        } else {
            showAlert(Alerts.AudioErrorTitle.rawValue, message: Alerts.AudioErrorMessage.rawValue)
        }
    }
}

