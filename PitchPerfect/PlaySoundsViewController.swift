//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Tiago Missão on 20/07/17.
//  Copyright © 2017 missao. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var audioEffectsStackView: UIStackView!
    @IBOutlet weak var innerAudioEffectsStackView1: UIStackView!
    @IBOutlet weak var innerAudioEffectsStackView2: UIStackView!
    @IBOutlet weak var innerAudioEffectsStackView3: UIStackView!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    
    /// Enum for identificates the button type by tag
    enum ButtonType: Int {case slow = 0, fast, chipmunk, vader, echo, reverb }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        // Update stackviews orientation before calculate layout constants
        rearrangeStackViewAxis(isPortrait: getLayoutOrientation() == .portrait)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    /// Obtains application orientation
    ///
    /// - Returns: application orientation
    func getLayoutOrientation() -> UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    
    /// Changes Axis of the inner stackviews
    ///
    /// - Parameter axisStyle: new stackview axis
    func setInnerStackViewAxis(axisStyle: UILayoutConstraintAxis) {
        innerAudioEffectsStackView1.axis = axisStyle
        innerAudioEffectsStackView2.axis = axisStyle
        innerAudioEffectsStackView3.axis = axisStyle
    }
    
    /// Changes Axis of outer stackview
    ///
    /// - Parameter axisStyle: new stackview axis
    func setOuterStackViewAxis(axisStyle: UILayoutConstraintAxis) {
        outerStackView.axis = axisStyle
        audioEffectsStackView.axis = axisStyle
    }
    
    
    
    /// Rearrange orientation of stackview
    ///
    /// - Parameter isPortrait: indicates the layout orientation is portrait
    func rearrangeStackViewAxis(isPortrait: Bool) {
        if isPortrait {
            setOuterStackViewAxis(axisStyle: .vertical)
            setInnerStackViewAxis(axisStyle: .horizontal)
        
        } else {
            setOuterStackViewAxis(axisStyle: .horizontal)
            setInnerStackViewAxis(axisStyle: .vertical)
        }
    }

    // MARK: - UIActions

    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
}
