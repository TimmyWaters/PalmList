//
//  PopoverViewController.swift
//  PalmList
//
//  Created by Timothy Waters on 2/19/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import UIKit

protocol AddItemDelegate {
    func addItemData(priority: String, itemText: String)
}

class AddItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: AddItemDelegate?
    
    let level = ["1", "2", "3", "4", "5"]
    var prioritySelection = ""
    var itemText = ""
    
    let headerID = "HeaderView"
    let footerID = "FooterView"
    
    let popCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        cv.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        cv.backgroundColor = UIColor(r: 211, g: 221, b: 230)
        
        return cv
    }()
    
    let textBox: UITextView = {
        let txtBox = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
        txtBox.font = UIFont(name: "Avenir Next", size: 18)
        txtBox.textColor = UIColor(r: 0, g: 84, b: 147)
        txtBox.textAlignment = NSTextAlignment.natural
        txtBox.backgroundColor = UIColor(r: 219, g: 229, b: 238)
        txtBox.isSelectable = true
        txtBox.dataDetectorTypes = UIDataDetectorTypes.link
        txtBox.layer.cornerRadius = 10
        txtBox.autocorrectionType = UITextAutocorrectionType.yes
        txtBox.spellCheckingType = UITextSpellCheckingType.yes
        txtBox.isEditable = true
        
        return txtBox
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 219, g: 229, b: 238)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(r: 0, g: 84, b: 147), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 24)
        
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 219, g: 229, b: 238)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor(r: 0, g: 84, b: 147), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 24)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        saveButton.addTarget(self, action: #selector(addItemData), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissPopover), for: .touchUpInside)
    }
    
    func setupView() {
        popCV.register(PopoverCollectionViewCell.self, forCellWithReuseIdentifier: "popCellID")
        popCV.delegate = self
        popCV.dataSource = self
        view.addSubview(popCV)
        view.addSubview(textBox)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        //        view.layer.borderColor = UIColor(r: 0, g: 84, b: 147).cgColor
        //        view.layer.borderWidth = 10
        popCV.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 300, height: 105)
        
        textBox.setAnchor(top: popCV.bottomAnchor, left: view.leftAnchor, bottom: cancelButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        cancelButton.setAnchor(top: textBox.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: saveButton.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 135, height: 50)
        
        saveButton.setAnchor(top: textBox.bottomAnchor, left: cancelButton.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 135, height: 50)
        
        popCV.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        popCV.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popCV.dequeueReusableCell(withReuseIdentifier: "popCellID", for: indexPath) as! PopoverCollectionViewCell
        cell.cellLabel.text = level[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        prioritySelection = level[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as? HeaderView else {fatalError("Invalid view type")}
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerID, for: indexPath) as? FooterView else {fatalError("Invalid view type")}
            return footerView
        default:
            assert(false, "Invalid element type")
        }
        
    }
    
    @objc func addItemData() {
        itemText = textBox.text
        if (prioritySelection != "" && itemText != "") {
            if self.delegate != nil {
                delegate?.addItemData(priority: prioritySelection, itemText: itemText)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func dismissPopover() {
        self.dismiss(animated: true, completion: nil)
    }
}
