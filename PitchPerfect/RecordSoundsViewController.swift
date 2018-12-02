//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Bernadett Kiss on 5/4/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(recording: false, labelString: "Tap to Record")
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(recording: true, labelString: "Recording in Progress")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordName = "recordedVoice.wav"
        let pathArray = [dirPath, recordName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playback, mode: .default)
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print("Cannot set up audioRecorder")
        }
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        configureUI(recording: false, labelString: "Tap to Record")
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Cannot deactivate audioSession")
        }
    }
    
    func configureUI(recording enable: Bool, labelString: String) {
        recordButton.isEnabled = !enable
        stopRecordingButton.isEnabled = enable
        recordingLabel.text = labelString
    }
    
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            configureUI(recording: false, labelString: "Try Recording Again")
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
