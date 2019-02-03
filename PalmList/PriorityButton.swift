//
//  PriorityButton.swift
//  PalmList
//
//  Created by Timothy Waters on 2/3/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import Foundation
import UIKit

class PriorityButton: UIButton, DropDownDelegate {
    var dropDownView = DropDownView()
    
    var height = NSLayoutConstraint()
    var isOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dropDownView = DropDownView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDownView.delegate = self
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        
        //        button.setImage(UIImage(named: "UnChecked"), for: .normal)
        //        button.setImage(UIImage(named: "Checked"), for: .selected)
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.titleLabel?.font = UIFont.init(name: "Avenir Next", size: 24)
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubviewToFront(dropDownView)
        
        dropDownView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropDownView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropDownView.priorityTableView.contentSize.height > 300 {
                self.height.constant = 300
            } else {
                self.height.constant = self.dropDownView.priorityTableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropDownView.layoutIfNeeded()
                self.dropDownView.center.y += self.dropDownView.frame.height / 2
            }, completion: nil)
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropDownView.center.y -= self.dropDownView.frame.height / 2
                self.dropDownView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropDownView.center.y -= self.dropDownView.frame.height / 2
            self.dropDownView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
}
