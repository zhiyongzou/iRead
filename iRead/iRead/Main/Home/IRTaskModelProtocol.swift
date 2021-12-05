//
//  IRTaskModelProtocol.swift
//  iRead
//
//  Created by zzyong on 2021/11/28.
//  Copyright © 2021 iread.com. All rights reserved.
//

import Foundation
import UIKit

enum IRTaskType: Int {
    case Today
    case Objective
}

protocol IRTaskModelProtocol: NSObjectProtocol {
    
    var title: String? { get set }
    var time: Double? { get set }
    var iconName: String? { get set }
    var iconBgColor: UIColor? { get set }
    var type: IRTaskType? { get set }
}
