//
//  EggTimerViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 29.01.2023.
//

import UIKit
import AVFoundation

class EggTimerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var secondTitleLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var player: AVAudioPlayer!
    
    //Rafadan,kayısı,katı yumurta haşlama süreleri: 150, 240, 360 saniye
    let eggTimes = ["Soft": 3, "Medium": 240, "Hard": 360]
    
    var secondsRemaining = 0
    var progressPercantage: Float = 0
    var totalTime = 0
    var hardnessType: String = ""
    
    //Her farklı butona basıldığında yeni bir timer oluşturulması için kullanılır
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        //Önceden çalışmaya devam eden timer varsa sonlandır
        timer.invalidate()
        
        // Soft, Medium, Hard
        if let hardness = sender.currentTitle {
          
            secondsRemaining = eggTimes[hardness]!
            totalTime = eggTimes[hardness]!
            hardnessType = hardness.lowercased()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsRemaining > 0 {
            
            secondTitleLabel.text = ""
            titleLabel.text = "\(secondsRemaining) seconds."
            progressPercantage = 1 - (Float(secondsRemaining) / Float(totalTime))
            progressBar.progress = progressPercantage
            secondsRemaining -= 1
            
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
    
    
    
    
    
    
    
    
    
}

