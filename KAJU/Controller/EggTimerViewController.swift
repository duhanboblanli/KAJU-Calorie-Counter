//
//  EggTimerViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 29.01.2023.
//

import UIKit
import AVFoundation
import CountdownLabel

class EggTimerViewController: UIViewController {
    
    @IBOutlet weak var countDownLabelFall: CountdownLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var player: AVAudioPlayer!
    
    //Rafadan,kayısı,katı yumurta haşlama süreleri: 150, 240, 360 saniye
    let eggTimes = ["Soft": 6, "Medium": 240, "Hard": 360]
    
    var secondsRemaining = 0
    var progressPercantage: Float = 0
    var totalTime = 0
    var hardnessType: String = ""
    var checkSecondTap: Bool = false
    var secondTapIndicator = 0
    var previousHardness: String = ""
    
    //Her farklı butona basıldığında yeni bir timer oluşturulması için kullanılır
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        sender.shake(duration: 0.7, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])
        //Önceden çalışmaya devam eden timer varsa sonlandır
        timer.invalidate()
    
        // Soft, Medium, Hard
        if let hardness = sender.currentTitle {
            if (hardness == previousHardness && secondTapIndicator == 1){
                secondTapIndicator = 0
                checkSecondTap = true
                updateTimer()
                return
            }
            secondTapIndicator = 1
            previousHardness = hardness
            checkSecondTap = false
            secondsRemaining = eggTimes[hardness]!
            totalTime = eggTimes[hardness]!
            hardnessType = hardness.lowercased()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer() {
        if !checkSecondTap{
            if secondsRemaining > 0 {
                secondTitleLabel.text = ""
                countDownLabelFall.setCountDownTime(minutes: TimeInterval(secondsRemaining))
                countDownLabelFall.animationType = .Fall
                countDownLabelFall.timeFormat = "mm:ss"
                countDownLabelFall.start()
                titleLabel.text = "Time Left:"
                progressPercantage = 1 - (Float(secondsRemaining) / Float(totalTime))
                progressBar.progress = progressPercantage
                secondsRemaining -= 1
                if secondsRemaining < 3 {
                    let url = Bundle.main.url(forResource: "beep_message_alarm", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                                player.play()
                    countDownLabelFall.shake(duration: 0.5, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])
                    titleLabel.shake(duration: 0.5, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])
                }
            }
            else {
                
                timer.invalidate()
                titleLabel.text = "DONE!"
                secondTitleLabel.text = "Your \(hardnessType) egg is ready. Bon appetit!"
                progressBar.progress = 1.0
                
                let url = Bundle.main.url(forResource: "guitar_alarm_sound", withExtension: "wav")
                            player = try! AVAudioPlayer(contentsOf: url!)
                            player.play()
            }
        }
        else{
            secondTitleLabel.text = "Note: Make sure the water is boiling before starting the timer."
            titleLabel.text = "How do you like your eggs?"
            progressBar.progress = 0.0
            countDownLabelFall.pause()
            countDownLabelFall.text = ""
        }
    }
    
    
    
    
    
    
    
    
    
}

