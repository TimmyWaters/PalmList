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
    func setPriority(cell: ListItemCell)
}

class ListItemCell: UITableViewCell {
    var delegate: ListItemCellDelegate?
    
    var priorityButton = PriorityButton(type: .custom)
    
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
    
//    var priorityButton: UIButton = {
//        let button = UIButton(type: .custom)
//        var dropDownView = DropDownView()
//        dropDownView = DropDownView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        dropDownView.translatesAutoresizingMaskIntoConstraints = false
//        
////        button.setImage(UIImage(named: "UnChecked"), for: .normal)
////        button.setImage(UIImage(named: "Checked"), for: .selected)
//        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = UIColor.white
//        button.layer.borderWidth = 2
//        button.layer.borderColor = UIColor.black.cgColor
//        button.titleLabel?.font = UIFont.init(name: "Avenir Next", size: 24)
//        return button
//    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.init(name: "Avenir Next", size: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        
        priorityButton.addTarget(self, action: #selector(setPriority), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(setChecked), for: .touchUpInside)
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.numberOfLines = 0
        itemLabel.lineBreakMode = .byWordWrapping
    }
    
    func setupCell() {
        addSubview(cellView)
        cellView.addSubview(checkButton)
        cellView.addSubview(priorityButton)
        cellView.addSubview(itemLabel)
        cellView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        cellView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        checkButton.setAnchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        checkButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        priorityButton.setAnchor(top: nil, left: checkButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        priorityButton.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor).isActive = true
        itemLabel.setAnchor(top: cellView.topAnchor, left: priorityButton.rightAnchor, bottom: cellView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        itemLabel.centerYAnchor.constraint(equalTo: priorityButton.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func setChecked() {
        self.delegate?.setChecked(cell: self)
    }
    
    @objc private func setPriority() {
        self.delegate?.setPriority(cell: self)
    }
}
