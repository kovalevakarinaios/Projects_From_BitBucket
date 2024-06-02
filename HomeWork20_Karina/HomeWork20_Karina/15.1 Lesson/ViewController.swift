//
//  ViewController.swift
//  15.1 Lesson
//
//  Created by Karina Kovaleva on 24.08.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    lazy var viewForMenu: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.frame.origin = CGPoint(x: self.view.frame.origin.x - self.view.frame.size.width / 2, y: 0)
        view.frame.size = CGSize(width: self.view.frame.size.width / 2, height: self.view.frame.height)
        return view
    }()
    lazy var backToMainButton: UIButton = {
        let backToMainButton = UIButton()
        backToMainButton.setTitle("To the main page", for: .normal)
        backToMainButton.backgroundColor = .black
        backToMainButton.frame = CGRect(x: self.viewForMenu.frame.width / 6,
                                        y: self.viewForMenu.frame.height / 2.5,
                                        width: self.viewForMenu.frame.size.width / 1.5,
                                        height: self.viewForMenu.frame.height / 15)
        backToMainButton.layer.cornerRadius = backToMainButton.frame.height / 2
        backToMainButton.titleLabel?.numberOfLines = 0
        backToMainButton.titleLabel?.textAlignment = .center
        return backToMainButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(viewForMenu)
        self.viewForMenu.addSubview(backToMainButton)
        let action = UIAction(handler: backToMainPage)
        backToMainButton.addAction(action, for: .touchUpInside)
    }
    @IBAction func showMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.viewForMenu.frame.origin = CGPoint(x: 0, y: 0)
            self.makeBlur()
        }
    }
    func makeBlur() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.tag = 1
        blurView.frame.origin = CGPoint(x: self.view.frame.size.width / 2, y: 0)
        blurView.frame.size = CGSize(width: self.view.frame.size.width / 2, height: self.view.frame.height)
        view.addSubview(blurView)
    }
    func backToMainPage(_ action: UIAction) {
        UIView.animate(withDuration: 0.4, delay: 0) {
        self.viewForMenu.frame.origin = CGPoint(x: self.view.frame.origin.x - self.view.frame.size.width / 2, y: 0)
        self.viewForMenu.frame.size = CGSize(width: self.view.frame.size.width / 2, height: self.view.frame.height)
        for subview in self.view.subviews where subview is UIVisualEffectView {
            subview.removeFromSuperview()
        }
    }
}
}
