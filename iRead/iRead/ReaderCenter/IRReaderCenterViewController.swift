//
//  IRReaderCenterViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRReaderCenterViewController: IRBaseViewcontroller {

    var shouldHideStatusBar = true
    var book: FRBook!
    private var pageLabel: DTAttributedLabel!
    
    //MARK: - Init
    
    convenience init(withBook book:FRBook) {
        self.init()
        self.book = book
    }
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.addNavigateTapGesture()
        pageLabel = DTAttributedLabel()
        self.view.addSubview(pageLabel)
        
        if let firstCahpter = book.tableOfContents.first {
            let chapter = IRBookChapter.init(withTocRefrence: firstCahpter)
            pageLabel.attributedString = chapter.content
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override var prefersStatusBarHidden: Bool {
        return self.shouldHideStatusBar
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageLabel.frame = self.view.bounds
    }
    
    //MARK: - Private
    
    func setupNavigationBar() {
        self.setupLeftBackBarButton()
    }
    
    //MARK: - Gesture
    func addNavigateTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didNavigateTapGestureClick(tapGesture:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func didNavigateTapGestureClick(tapGesture: UITapGestureRecognizer) {
        self.shouldHideStatusBar = !self.shouldHideStatusBar;
        self.navigationController?.setNavigationBarHidden(self.shouldHideStatusBar, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
