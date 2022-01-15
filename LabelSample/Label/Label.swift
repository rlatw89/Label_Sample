//
//  Label.swift
//  LabelSample
//
//  Created by Taewan_MacBook on 2022/01/16.
//

import UIKit

let lineSpacing: CGFloat = 2
var fontIncrement: CGFloat = 0

class Label: UILabel {
    
    private lazy var storage: NSTextStorage = {
        let storage = NSTextStorage()
        return storage
    } ()
    
    let layoutManger = UnderlineLayoutManager()
}
