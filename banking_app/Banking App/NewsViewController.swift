//
//  NewsViewController.swift
//  Banking App
//
//  Created by Karina Kovaleva on 12.05.23.
//

import UIKit

class NewsViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    var news: [News] = []
    
    private lazy var newsScrollView: UIScrollView = {
        var newsScrollView = UIScrollView()
        newsScrollView.translatesAutoresizingMaskIntoConstraints = false
        newsScrollView.isPagingEnabled = true
        newsScrollView.showsHorizontalScrollIndicator = false
        return newsScrollView
    }()
    
    private lazy var newsStackView: UIStackView = {
        var newsStackView = UIStackView()
        newsStackView.translatesAutoresizingMaskIntoConstraints = false
        newsStackView.axis = .horizontal
        newsStackView.alignment = .center
        newsStackView.spacing = 140
        return newsStackView
    }()

    private lazy var leftImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    private lazy var centerImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        networkManager.getNews { result in
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    self.news = news
                    self.leftImageView.image = UIImage(data: self.transformURLToData(url: self.news[0].img))
                    self.centerImageView.image = UIImage(data: self.transformURLToData(url: self.news[1].img))
                    self.rightImageView.image = UIImage(data: self.transformURLToData(url: self.news[2].img))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.view.addSubview(self.newsScrollView)
        self.newsScrollView.addSubview(self.newsStackView)
        self.setupImageViews()
      
        NSLayoutConstraint.activate([
            self.newsScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.newsScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -600),
            self.newsScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.newsScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),

            self.newsStackView.bottomAnchor.constraint(equalTo: self.newsScrollView.bottomAnchor),
            self.newsStackView.rightAnchor.constraint(equalTo: self.newsScrollView.rightAnchor),
            self.newsStackView.leftAnchor.constraint(equalTo: self.newsScrollView.leftAnchor),
            self.newsStackView.topAnchor.constraint(equalTo: self.newsScrollView.topAnchor),
            
            self.leftImageView.topAnchor.constraint(equalTo: self.newsScrollView.topAnchor, constant: 5),
            self.leftImageView.bottomAnchor.constraint(equalTo: self.newsScrollView.bottomAnchor, constant: -5),
            self.leftImageView.leadingAnchor.constraint(equalTo: self.newsScrollView.leadingAnchor, constant: 70),

            self.centerImageView.topAnchor.constraint(equalTo: self.newsScrollView.topAnchor, constant: 5),
            self.centerImageView.bottomAnchor.constraint(equalTo: self.newsScrollView.bottomAnchor, constant: -5),
            
            self.rightImageView.topAnchor.constraint(equalTo: self.newsScrollView.topAnchor, constant: 5),
            self.rightImageView.bottomAnchor.constraint(equalTo: self.newsScrollView.bottomAnchor, constant: -5),
            self.rightImageView.rightAnchor.constraint(equalTo: self.newsScrollView.rightAnchor, constant: -70)
        ])
    }
    
    func transformURLToData (url: String) -> Data {
        guard let url = URL(string: url) else { print("Error: cannot create URL"); return Data() }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error")
        }
        return Data()
    }
    
    func setupImageViews() {
        let imageViews = [leftImageView, centerImageView, rightImageView]
        
        imageViews.forEach { view in
            self.view.translatesAutoresizingMaskIntoConstraints = false
            self.newsStackView.addArrangedSubview(view)
        }
    }
    
//    func setupScrollView() {
//        let viewsCount: CGFloat = 3.0
//        let contentWidth: CGFloat = itemWidth * viewsCount + spaceBetweenItems * (viewsCount - 1.0)
//    }
}
