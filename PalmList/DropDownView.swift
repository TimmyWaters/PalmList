//
//  DropDownView.swift
//  PalmList
//
//  Created by Timothy Waters on 2/3/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import Foundation
import UIKit

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let priorityLevel = ["1", "2", "3", "4", "5"]
    var priorityTableView = UITableView()
    var delegate: DropDownDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        priorityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        priorityTableView.backgroundColor = .white
        priorityTableView.delegate = self
        priorityTableView.dataSource = self
        priorityTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priorityTableView)
        
        priorityTableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        priorityTableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        priorityTableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        priorityTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priorityLevel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = priorityLevel[indexPath.row]
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test")
    }
}
