//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kathryn on 3/9/15.
//  Copyright (c) 2015 KSamalin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func adjustRate(rate: Float) {
        fullStop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()

    }
    
    func adjustPitch(pitch: Float) {
        fullStop()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func fullStop() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

    }

    @IBAction func normalPlayback(sender: UIButton) {
        adjustRate(1.0)
    }
    
    @IBAction func slowPlayback(sender: UIButton) {
        adjustRate(0.5)
    }
    
    @IBAction func fastPlayback(sender: UIButton) {
        adjustRate(2.0)
    }
    
    @IBAction func highPlayback(sender: UIButton) {
        adjustPitch(1200)
    }
    
    @IBAction func lowPlayback(sender: UIButton) {
        adjustPitch(-1200)
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        fullStop()
    }
    
}

