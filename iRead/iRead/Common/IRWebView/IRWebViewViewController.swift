//
//  IRWebViewViewController.swift
//  iRead
//
//  Created by zzyong on 2022/2/13.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit
import WebKit
import CommonLib

class IRWebViewViewController: IRBaseViewcontroller, UISearchBarDelegate, WKNavigationDelegate, WKUIDelegate {

    let kEstimatedProgress = "estimatedProgress"
    var isLoading = false
    var shouldReload = false
    
    var urlString: String?  {
        willSet {
            shouldReload = true
        }
    }
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.minimumFontSize = 10
        configuration.userContentController = WKUserContentController()
        let webView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.backgroundColor = .white
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.isHidden = true
        progressView.progressTintColor = .systemBlue
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addSubview(progressView)
            progressView.snp.makeConstraints { make in
                make.height.equalTo(2)
                make.width.bottom.equalTo(navigationBar)
            }
        }
        return progressView
    }()
    
    //MARK: Override
    
    deinit {
        webView.removeObserver(self, forKeyPath: kEstimatedProgress)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftBackBarItem()
        view.addSubview(webView)
        webView.addObserver(self, forKeyPath: kEstimatedProgress, options: .new, context: nil)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressView.isHidden = !isLoading
        if shouldReload {
            shouldReload = false
            reloadWebView()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.isHidden = true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    //MARK: Private
    
    func reloadWebView() {
        if let urlString = urlString?.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            webView.load(URLRequest(url: URL.init(string: urlString)!))
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kEstimatedProgress {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func handleWebViewLoadSuccess(_ success: Bool, error: Error?) {
        isLoading = false
        progressView.isHidden = true
        progressView.progress = 0.0
        
        if error != nil {
            IRDebugLog("\(error!)")
        }
    }
    
    //MARK: WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.progress = 0.0
        progressView.isHidden = false
        isLoading = true
        IRDebugLog(webView.url?.absoluteString)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        handleWebViewLoadSuccess(true, error: nil)
        IRDebugLog("")
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleWebViewLoadSuccess(false, error: error)
        IRDebugLog("")
    }
    
    // https://stackoverflow.com/questions/30603671/open-a-wkwebview-target-blank-link-in-safari
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        DispatchQueue.main.async {
            webView .load(navigationAction.request)
        }
        return nil
    }
}
