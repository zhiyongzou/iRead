//
//  IRReadTimePickerView.swift
//  iRead
//
//  Created by zzyong on 2021/12/5.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit
import IRCommonLib

class IRReadTimePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum PickerComponentType: Int {
        case time = 0  ///< 时间
        case unit = 1  ///< 单位
    }
    
    typealias SelectDoneAction = (Int) -> Void
    
    let titleViewHeight = 50.0
    let pickerViewHeight = 216.0
    
    var contentView = UIView()
    var titleLabel = UILabel()
    var divideLine = UIView()
    var doneButton = UIButton(type: .custom)
    var bgView = UIView()
    var pickerView = UIPickerView()
    
    var selectDoneAction: SelectDoneAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = bounds
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.width, height: titleViewHeight)
        
        let btnW = 50.0
        doneButton.frame = CGRect(x: self.width - btnW - 10, y: 0, width: btnW, height: titleViewHeight)
        divideLine.frame = CGRect(x: 0, y: titleViewHeight - 0.5, width: self.width, height: 0.5)
        pickerView.frame = CGRect(x: 0, y: titleViewHeight, width: self.width, height: pickerViewHeight)
    }
    
    func setupSubviews() {
        bgView.backgroundColor = .init(white: 0.2, alpha: 0.5)
        addSubview(bgView)
        
        contentView.backgroundColor = .white
        addSubview(contentView)
        
        titleLabel.text = "每日阅读目标"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 18)
        contentView.addSubview(titleLabel)
        
        doneButton.addTarget(self, action: #selector(didClickDoneButtong), for: .touchUpInside)
        doneButton.titleLabel?.font = .systemFont(ofSize: 15)
        doneButton.contentHorizontalAlignment = .right
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.setTitleColor(.init(white: 0, alpha: 0.5), for: .highlighted)
        doneButton.setTitle("完成", for: .normal)
        contentView.addSubview(doneButton)
        
        divideLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        contentView.addSubview(divideLine)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        contentView.addSubview(pickerView)
    }
    
    //MARK: - Action
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchView = touches.first?.view
        if touchView == bgView {
            dismiss()
        }
    }
    
    @objc func didClickDoneButtong() {
        dismiss()
    }
    
    //MARK: - Public
    
    func showIn(targetView: UIView, currentReadTime: Int) {
        targetView.addSubview(self)
        bgView.alpha = 0
        contentView.frame = CGRect(x: 0, y: self.height, width: self.width, height: pickerViewHeight + titleViewHeight)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.contentView.y = self.height - self.contentView.height
            self.bgView.alpha = 1
        } completion: { finish in
            self.pickerView.selectRow(currentReadTime - 1, inComponent: PickerComponentType.time.rawValue, animated: true)
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.contentView.y = self.height
            self.bgView.alpha = 0
        } completion: { finish in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - UIPickerViewDelegate, UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == PickerComponentType.time.rawValue {
            return 1440
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 72
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if view is UILabel {
            label = view as! UILabel
        } else {
            label = UILabel()
        }
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        if component == PickerComponentType.time.rawValue {
            label.textAlignment = .right
            label.text = "\(row + 1)"
        } else {
            label.textAlignment = .center
            label.text = "分钟/天"
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == PickerComponentType.time.rawValue {
            IRDebugLog("\(row + 1) 分钟/天")
            if selectDoneAction != nil {
                selectDoneAction!(row + 1)
            }
        }
    }
}
