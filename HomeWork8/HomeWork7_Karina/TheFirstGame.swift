//
//  TheFirstGame.swift
//  HomeWork7_Karina
//
//  Created by Karina Kovaleva on 27.07.22.
//

import UIKit

var counter = 0

enum Direction: String {
    case left
    case right
    case up
    case down
}

class TheFirstGame: UIViewController {
    
    let mainField = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 680))
    let scoreLabel = UILabel(frame: CGRect(x: 30, y: 705, width: 70, height: 90))
    let carrotImage = UIButton(frame: CGRect(x: Int.random(in: 10...370), y: Int.random(in: 10...640), width: 40, height: 40))
    let circle = UIButton(frame: CGRect(x: 212, y: 340, width: 100, height: 100))
    let rabbit = UIImage(named: "rabbit")
    let labelForMotionAndError = UILabel(frame: CGRect(x: 300, y: 730, width: 100, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonUp = UIButton(frame: CGRect(x: 180, y: 690, width: 50, height: 50))
        let buttonDown = UIButton(frame: CGRect(x: 180, y: 770, width: 50, height: 50))
        let buttonLeft = UIButton(frame: CGRect(x: 140, y: 730, width: 50, height: 50))
        let buttonRight = UIButton(frame: CGRect(x: 220, y: 730, width: 50, height: 50))
        
        let actionUp = UIAction(handler: buttonTappedUp)
        let actionDown = UIAction(handler: buttonTappedDown)
        let actionLeft = UIAction(handler: buttonTappedLeft)
        let actionRight = UIAction(handler: buttonTappedRight)
        
        buttonUp.addAction(actionUp, for: .touchUpInside)
        buttonDown.addAction(actionDown, for: .touchUpInside)
        buttonLeft.addAction(actionLeft, for: .touchUpInside)
        buttonRight.addAction(actionRight, for: .touchUpInside)
        
        view.backgroundColor = .white
        self.view.addSubview(mainField)
        mainField.backgroundColor = UIColor(red: 255 / 255, green: 222 / 255, blue: 173 / 255, alpha: 1)
    
        self.view.addSubview(buttonUp)
        buttonUp.setBackgroundImage(UIImage(named: "Up"), for: .normal)

        self.view.addSubview(buttonDown)
        buttonDown.setBackgroundImage(UIImage(named: "Down"), for: .normal)
        
        self.view.addSubview(buttonRight)
        buttonRight.setBackgroundImage(UIImage(named: "Right"), for: .normal)

        self.view.addSubview(buttonLeft)
        buttonLeft.setBackgroundImage(UIImage(named: "Left"), for: .normal)
        
        self.view.addSubview(labelForMotionAndError)
        labelForMotionAndError.font = UIFont (name: fontForAnothersLabels, size: 20)
        labelForMotionAndError.textAlignment = .center
        
        mainField.addSubview(circle)
        circle.center = mainField.center
        circle.setBackgroundImage(rabbit, for: .normal)
        
        mainField.addSubview(carrotImage)
        carrotImage.setBackgroundImage(UIImage(named: "carrot"), for: .normal)
        
        self.view.addSubview(scoreLabel)
        scoreLabel.lineBreakMode = .byWordWrapping
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 0
        scoreLabel.font = UIFont (name: fontForAnothersLabels, size: 20)
        scoreLabel.text = "Score:\n \(counter)\u{1F955}"
       
        // Do any additional setup after loading the view.
    }
    func buttonTappedUp(_ action: UIAction) {
        step(direction: .up)
    }
    
    func buttonTappedRight(_ action: UIAction) {
        step(direction: .right)
    }

    func buttonTappedLeft(_ action: UIAction) {
        step(direction: .left)
    }

    func buttonTappedDown(_ action: UIAction) {
        step(direction: .down)
    }
    
    func step (direction: Direction) {
        switch direction {
        case .left:
            if circle.frame.contains(carrotImage.frame) {
                carrotImage.frame = CGRect(x: Int.random(in: 10...370), y: Int.random(in: 10...640), width: 40, height: 40)
                circle.frame.origin.x -= 10
                counter += 1
                scoreLabel.text = "Score:\n \(counter)\u{1F955}"
            } else if circle.frame.origin.x < 0 {
                labelForMotionAndError.text = "Error"
                x = 0
            } else {
                circle.frame.origin.x -= 10
                labelForMotionAndError.text = "Left"
            }
        case .right:
            if circle.frame.contains(carrotImage.frame) {
                carrotImage.frame = CGRect(x: Int.random(in: 10...370), y: Int.random(in: 10...640), width: 40, height: 40)
                circle.frame.origin.x -= 10
                counter += 1
                scoreLabel.text = "Score:\n \(counter)\u{1F955}"
            } else if circle.frame.origin.x > 312 {
                labelForMotionAndError.text = "Error"
                x = 312
            } else {
                circle.frame.origin.x += 10
                labelForMotionAndError.text = "Right"
            }
        case .up:
            if circle.frame.contains(carrotImage.frame) {
                carrotImage.frame = CGRect(x: Int.random(in: 10...370), y: Int.random(in: 10...640), width: 40, height: 40)
                circle.frame.origin.x -= 10
                counter += 1
                scoreLabel.text = "Score:\n \(counter)\u{1F955}"
            }  else if circle.frame.origin.y < 1 {
                labelForMotionAndError.text = "Error"
                y = 1
            } else {
                circle.frame.origin.y -= 10
                labelForMotionAndError.text = "Up"
            }
        case .down:
            if circle.frame.contains(carrotImage.frame) {
                carrotImage.frame = CGRect(x: Int.random(in: 10...370), y: Int.random(in: 10...640), width: 40, height: 40)
                circle.frame.origin.x -= 10
                counter += 1
                scoreLabel.text = "Score:\n \(counter)\u{1F955}"
            } else if circle.frame.origin.y > 570 {
                labelForMotionAndError.text = "Error"
                y = 570
            } else {
                circle.frame.origin.y += 10
                labelForMotionAndError.text = "Down"
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

