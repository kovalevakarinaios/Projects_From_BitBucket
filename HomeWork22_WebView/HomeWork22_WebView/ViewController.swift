//
//  ViewController.swift
//  HomeWork22_WebView
//
//  Created by Karina Kovaleva on 25.10.22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        activityIndicator.style = .large
        activityIndicator.color = .lightGray
        activityIndicator.center = self.view.center
        return activityIndicator
    }()

    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0,
                                              y: searchBar.frame.height + self.view.frame.height / 17,
                                              width: self.view.frame.width,
                                              height: self.view.frame.height - searchBar.frame.height * 2.5))
        return webView
    }()

    lazy var reloadButton: UIButton = {
        let reloadButton = UIButton(frame: CGRect(x: self.view.frame.width * 2/5,
                                                  y: self.view.frame.height - searchBar.frame.height,
                                                  width: self.view.frame.width / 5,
                                                  height: searchBar.frame.height))
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
        reloadButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath",
                                      withConfiguration: configuration), for: .normal)
        reloadButton.tintColor = .darkGray
        return reloadButton
    }()

    lazy var forwardButton: UIButton = {
        let forwardButton = UIButton(frame: CGRect(x: self.view.frame.width * 4/5,
                                                   y: self.view.frame.height - searchBar.frame.height,
                                                   width: self.view.frame.width / 5,
                                                   height: searchBar.frame.height))
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
        forwardButton.setImage(UIImage(systemName: "chevron.forward", withConfiguration: configuration), for: .normal)
        forwardButton.tintColor = .darkGray
        return forwardButton
    }()

    lazy var backwardButton: UIButton = {
        let backwardButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - searchBar.frame.height,
                                                    width: self.view.frame.width / 5,
                                                    height: searchBar.frame.height))
        var configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
        backwardButton.setImage(UIImage(systemName: "chevron.backward", withConfiguration: configuration), for: .normal)
        backwardButton.tintColor = .darkGray
        return backwardButton
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: Int(self.view.frame.height) / 17,
                                                  width: Int(self.view.frame.width),
                                                  height: Int(self.view.frame.height) / 10))
        searchBar.barTintColor = .lightGray
        searchBar.placeholder = "Запрос или веб-сайт"
        searchBar.returnKeyType = .search
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray

        self.view.addSubview(webView)
        self.view.addSubview(backwardButton)
        self.view.addSubview(forwardButton)
        self.view.addSubview(reloadButton)
        self.view.addSubview(searchBar)
        self.webView.addSubview(activityIndicator)

        guard let url = URL(string: "https://www.google.com") else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)

        activityIndicator.startAnimating()

        webView.navigationDelegate = self
        searchBar.delegate = self
        activityIndicator.hidesWhenStopped = true

        backwardButton.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }

    @objc func backwardButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc func forwardButtonTapped() {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    @objc func reloadButtonTapped() {
        webView.reload()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }

        if text.starts(with: "https://") {
            guard let url = URL(string: text) else { return }
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        } else if text.starts(with: "www") || text.starts(with: "Www") {
            guard let url = URL(string: "https://" + text) else { return }
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        } else {
            guard let url = URL(string: "https://www.google.com/search?q=" + text) else { return }
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}
