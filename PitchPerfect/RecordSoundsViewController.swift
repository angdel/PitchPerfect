//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Angel Delgado on 10/7/16.
//  Copyright © 2016 Angel Delgado. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        print("Button Pressed")
        recordingLabel.text = "Recording in Progress..."
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    

    @IBAction func stopRecording(_ sender: AnyObject) {
        print("Stop Recording Pressed")
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive (false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear Called")
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRedorder did Finish Recording")
        if (flag) {
        self.performSegue(withIdentifier: "StopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of Recording Failed")
        }
        func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if (segue.identifier == "stopRecording") {
                let playSoundsVC = segue.destination as! PlaySoundsViewController
                let recordedAudioURL = sender as! NSURL
                playSoundsVC.recordedAudioURL = recordedAudioURL
            }
        }
    }
}

