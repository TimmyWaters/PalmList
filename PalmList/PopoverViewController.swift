//
//  PopoverViewController.swift
//  PalmList
//
//  Created by Timothy Waters on 2/19/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import UIKit

protocol PriorityLevelDelegate: class {
    func setPriorityLevel(level: String)
}

class PopoverViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: PriorityLevelDelegate?
    
    var index = IndexPath()
    
    let level = ["1", "2", "3", "4", "5"]
    
    let popoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(r: 0, g: 84, b: 147)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        popoverCollectionView.register(PopoverCell.self, forCellWithReuseIdentifier: "popCell")
        popoverCollectionView.delegate = self
        popoverCollectionView.dataSource = self
        view.addSubview(popoverCollectionView)
        popoverCollectionView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popoverCollectionView.dequeueReusableCell(withReuseIdentifier: "popCell", for: indexPath) as! PopoverCell
        cell.level.text = level[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 8, bottom: 20, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
        delegate?.setPriorityLevel(level: level[indexPath.item])
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
