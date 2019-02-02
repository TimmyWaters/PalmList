//
//  ListItemCell.swift
//  PalmList
//
//  Created by Timothy Waters on 1/27/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import UIKit
import Foundation

protocol ListItemCellDelegate {
    func setChecked(cell: ListItemCell)
}

class ListItemCell: UITableViewCell {
    var delegate: ListItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.setCellShadow()
        return view
    }()
    
    let checkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "UnChecked"), for: .normal)
        button.setImage(UIImage(named: "Checked"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return button
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.init(name: "Avenir Next", size: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        
        checkButton.addTarget(self, action: #selector(setChecked), for: .touchUpInside)
    }
    
    func setupCell() {
        addSubview(cellView)
        cellView.addSubview(checkButton)
        cellView.addSubview(itemLabel)
        
        cellView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        checkButton.setAnchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        checkButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        itemLabel.setAnchor(top: nil, left: checkButton.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        itemLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func setChecked() {
        self.delegate?.setChecked(cell: self)
    }
}
