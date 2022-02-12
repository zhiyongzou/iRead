//
//  IRSearchWebViewController.swift
//  iRead
//
//  Created by zzyong on 2022/1/22.
//  Copyright © 2022 iread.com. All rights reserved.
//

import WebKit
import SnapKit
import CommonLib

open class IRSearchWebViewController: IRBaseViewcontroller, UIScrollViewDelegate, UISearchBarDelegate, WKNavigationDelegate, WKUIDelegate, IRSearchWebTabbarDelegate, IRSearchShortcutViewDelegate {
    
    let kEstimatedProgress = "estimatedProgress"
    let searchTextMaxCount = 30
    
    var isLoading = false
    var shouldBeginEditing = false
 
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.minimumFontSize = 10
        configuration.userContentController = WKUserContentController()
        let webView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.backgroundColor = .white
        return webView
    }()
    
    lazy var searchBarView: UISearchBar = {
        let searchBarView = UISearchBar()
        searchBarView.placeholder = "搜索"
        searchBarView.delegate = self
        return searchBarView
    }()
    
    lazy var tabbarView: IRSearchWebTabbar = {
        let tabbarView = IRSearchWebTabbar()
        tabbarView.delegate = self
        return tabbarView
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
    
    lazy var searchShortcutView: IRSearchShortcutView = {
        let searchShortcutView = IRSearchShortcutView()
        searchShortcutView.delegate = self
        return searchShortcutView
    }()
    
    //MARK: Override
    
    deinit {
        webView.removeObserver(self, forKeyPath: kEstimatedProgress)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.addObserver(self, forKeyPath: kEstimatedProgress, options: .new, context: nil)
        
        navigationItem.titleView = searchBarView
        navigationItem.hidesBackButton = true
        
        let closeImg = UIImage(named: "circle_close")?.original
        let closeItem = UIBarButtonItem(image: closeImg, style: .plain, target: self, action: #selector(didClickCloseButton))
        navigationItem.rightBarButtonItem = closeItem
        
        view.addSubview(tabbarView)
        
        let searchShortcutY = navigationController?.navigationBar.frame.maxY ?? 0
        searchShortcutView.frame = CGRect(x: 0, y: searchShortcutY, width: view.width, height: view.height - searchShortcutY)
        view.addSubview(searchShortcutView)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressView.isHidden = !isLoading
        if shouldBeginEditing {
            shouldBeginEditing = false
            searchBarView.becomeFirstResponder()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.isHidden = true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = view.height
        let width = view.width
        
        var tabbarH = 40.0
        if #available(iOS 11.0, *) {
            tabbarH += view.safeAreaInsets.bottom
        }
        tabbarView.frame = CGRect(x: 0, y: height - tabbarH, width: width, height: tabbarH)
        
        let webViewY = navigationController?.navigationBar.frame.maxY ?? 0
        webView.frame = CGRect(x: 0, y: webViewY, width: view.width, height: view.height - webViewY - tabbarH)
    }
    
    //MARK: Private
    
    func updateSearchBarText(_ url: URL?) {
        guard let searchUrl = url?.absoluteString else { return }
        if !searchUrl.hasPrefix(bingSearchUrl) {
            return
        }
        IRDebugLog(searchUrl)
        var firstParamIndex = searchUrl.firstIndex(of: "+")
        if firstParamIndex == nil {
            firstParamIndex = searchUrl.firstIndex(of: "&")
        }
        if firstParamIndex == nil {
            firstParamIndex = searchUrl.endIndex
        }
        let targetUrl = searchUrl.prefix(upTo: firstParamIndex!)
        IRDebugLog(targetUrl)
        let serachPrefixIndex = searchUrl.index(searchUrl.startIndex, offsetBy: bingSearchUrl.count)
        let searchText = targetUrl.suffix(from: serachPrefixIndex)
        IRDebugLog(searchText)
        searchBarView.text = searchText.removingPercentEncoding
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kEstimatedProgress {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func updateTabbarBackForwardState() {
        tabbarView.backButton.isEnabled = webView.backForwardList.backList.count > 0
        tabbarView.forwardButton.isEnabled = webView.backForwardList.forwardList.count > 0
    }
    
    func handleWebViewLoadSuccess(_ success: Bool, error: Error?) {
        isLoading = false
        progressView.isHidden = true
        progressView.progress = 0.0
        updateTabbarBackForwardState()
        
        if error != nil {
            IRDebugLog("\(error!)")
        }
    }
    
    //MARK: Actions
    
    @objc func didClickCloseButton() {
        navigationController?.popViewController(animated: true)
        webView.loadHTMLString("", baseURL: nil)
    }
    
    //MARK: IRSearchShortcutViewDelegate
    
    func searchShortcutViewWillBeginDragging(_ shortcutView: IRSearchShortcutView) {
        searchBarView.endEditing(true)
    }
    
    func searchShortcutView(_ shortcutView: IRSearchShortcutView, didSearch shortcut: IRSearchShortcutModel?) {
        guard let shortcut = shortcut else { return }
        guard let content = shortcut.content else { return }
        IRDebugLog(shortcut.content)
        var queryUrlString = bingSearchUrl
        if shortcut.type == .baidu {
            queryUrlString = baiduUrl
        } else if shortcut.type == .sogou {
            queryUrlString = sogouUrl
        } else {
            if let content = content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                queryUrlString += content
            }
        }
        let request = URLRequest(url: URL.init(string: queryUrlString)!)
        webView.load(request)
        searchBarView.endEditing(true)
        searchShortcutView.isHidden = true
    }
    
    //MARK: UIScrollViewDelegate
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarView.endEditing(true)
    }
    
    //MARK: UISearchBarDelegate.
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let searchText = searchBar.text, let queryText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return
        }
        IRSearchShortcutManager.saveSearchText(searchText)
        searchShortcutView.isHidden = true
        let queryUrlString = bingSearchUrl + queryText
        let request = URLRequest(url: URL.init(string: queryUrlString)!)
        webView.load(request)
        
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchShortcutView.isHidden = false
        progressView.isHidden = true
        webView.loadHTMLString("", baseURL: nil)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count <= searchTextMaxCount {
            return
        }
        let searchString = (searchText as NSString)
        let composedRange = searchString.rangeOfComposedCharacterSequence(at: searchTextMaxCount)
        if composedRange.length == 1 {
            searchBar.text = searchString.substring(to: searchTextMaxCount)
        } else {
            let range = searchString.rangeOfComposedCharacterSequences(for: NSRange(location: 0, length: searchTextMaxCount))
            searchBar.text = searchString.substring(with: range)
        }
    }
    
    //MARK: IRSearchWebTabbarDelegate
    
    func searchWebTabbarDidClickBackButton(_ topBar: IRSearchWebTabbar) {
        webView.goBack()
        updateTabbarBackForwardState()
    }
    
    func searchWebTabbarDidClickForwardButton(_ topBar: IRSearchWebTabbar) {
        webView.goForward()
        updateTabbarBackForwardState()
    }
    
    func searchWebTabbarDidClickReloadButton(_ topBar: IRSearchWebTabbar) {
        webView.reload()
    }
    
    //MARK: WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.progress = 0.0
        progressView.isHidden = false
        isLoading = true
        updateSearchBarText(webView.url)
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

//webView.evaluateJavaScript("document.body.style.backgroundColor=\"#ffffff\"") { any, error in
//    if error != nil {
//        IRDebugLog(error.debugDescription)
//    }
//}
