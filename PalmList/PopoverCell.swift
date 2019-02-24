//
//  PopoverCell.swift
//  PalmList
//
//  Created by Timothy Waters on 2/16/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import UIKit
import Foundation

class PopoverCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        self.backgroundColor = .white
        self.addSubview(level)
        
        level.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        self.setCellShadow()
    }
    
    let level: UILabel = {
        let label = UILabel()
        label.text = "T"
        label.textColor = UIColor(r: 0, g: 84, b: 147)
        label.font = UIFont(name: "Avenir Next", size: 24)
        label.textAlignment = .center
        return label
    }()
}
