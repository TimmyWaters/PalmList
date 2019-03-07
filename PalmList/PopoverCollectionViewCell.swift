//
//  PopoverCollectionViewCell.swift
//  PalmList
//
//  Created by Timothy Waters on 3/6/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import UIKit

class PopoverCollectionViewCell: UICollectionViewCell {
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        label.textColor = .white
        label.font = UIFont.init(name: "Avenir Next", size: 24)
        label.backgroundColor = UIColor(r: 0, g: 84, b: 147)
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        self.setCellShadow()
    }
}
