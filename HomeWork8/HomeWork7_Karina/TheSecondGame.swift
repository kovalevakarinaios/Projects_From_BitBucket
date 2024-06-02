//
//  TheSecondGame.swift
//  HomeWork7_Karina
//
//  Created by Karina Kovaleva on 27.07.22.
//


import UIKit

var x: CGFloat = 0
var y: CGFloat = 0
enum Colors: String, CaseIterable {
    case black
    case darkGray
    case lightGray
    case white
    case gray
    case red
    case green
    case blue
    case cyan
    case yellow
    case magenta
    case orange
    case purple
    case brown
}

class TheSecondGame: UIViewController {
    let mainField = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 700))
    let buttonForSecondGame = UIButton(frame: CGRect(x: 107, y: 730, width: 200, height: 70))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let action = UIAction(handler: buttonTapped)
                      
        view.backgroundColor = .white
        self.view.addSubview(mainField)
        mainField.backgroundColor = UIColor(red: 255 / 255, green: 228 / 255, blue: 196 / 255, alpha: 1)
        self.view.addSubview(buttonForSecondGame)
        buttonForSecondGame.backgroundColor = UIColor(red: 176 / 255, green: 224 / 255, blue: 230 / 255, alpha: 1)
        buttonForSecondGame.layer.cornerRadius = 35
        buttonForSecondGame.setTitle("Tap", for: .normal)
        buttonForSecondGame.titleLabel?.font = UIFont(name: fontForAnothersLabels, size: 25)
        buttonForSecondGame.layer.shadowColor = UIColor.gray.cgColor
        buttonForSecondGame.layer.shadowOffset = CGSize(width: 5, height: 5)
        buttonForSecondGame.layer.shadowOpacity = 0.7
        buttonForSecondGame.layer.shadowRadius = 2
        buttonForSecondGame.addAction(action, for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func buttonTapped(_ action: UIAction) {
        while x < 351 {
        let newRectangle = UIView()
        let label = UILabel()
        mainField.addSubview(newRectangle)
        mainField.addSubview(label)
        newRectangle.frame = CGRect(x: x, y: y, width: 70, height: 70)
        newRectangle.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        newRectangle.layer.borderWidth = 1
        label.frame = CGRect(x: x, y: y, width: 70, height: 35)
        label.center = newRectangle.center
        x += 70
        getRandomColor(for: label)
        func getRandomColor(for label: UILabel) {
            let color = Colors.allCases[Int.random(in: 0...13)]
            switch color {
            case .black:
                newRectangle.backgroundColor = .black
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .darkGray:
                newRectangle.backgroundColor = .darkGray
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .lightGray:
                newRectangle.backgroundColor = .lightGray
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .white:
                    newRectangle.backgroundColor = .white
                label.textAlignment = .center
                label.textColor = .black
                label.text = "\(color.rawValue)"
            case .gray:
                newRectangle.backgroundColor = .gray
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .red:
                newRectangle.backgroundColor = .red
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .green:
                newRectangle.backgroundColor = .green
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .blue:
                newRectangle.backgroundColor = .blue
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .cyan:
                newRectangle.backgroundColor = .cyan
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .yellow:
                newRectangle.backgroundColor = .yellow
                label.textAlignment = .center
                label.textColor = .black
                label.text = "\(color.rawValue)"
            case .magenta:
                newRectangle.backgroundColor = .magenta
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .orange:
                newRectangle.backgroundColor = .orange
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .purple:
                newRectangle.backgroundColor = .purple
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            case .brown:
                newRectangle.backgroundColor = .brown
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\(color.rawValue)"
            }
        }
            if x > 352 && y > 600 {
                getRandomColor(for: label)
                x = 0
                y = 0
                break
            } else if x > 360 {
                getRandomColor(for: label)
                x = 0
                y += 70
            }
        }
    }
}

