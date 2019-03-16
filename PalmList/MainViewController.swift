//
//  MainViewController.swift
//  PalmList
//
//  Created by Timothy Waters on 1/26/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListItemCellDelegate, PopoverDelegate, AddItemDelegate {
    
    let listTableView = UITableView()
    
    let sectionArray = ["Priority 1", "Priority 2", "Priority 3", "Priority 4", "Priority 5"]
    
    var items: [[ListItem]] = [[], [], [], [], []]
    
    var popoverCellIndex = IndexPath()
    
    var navBarTitle: UINavigationItem = {
        let title = UINavigationItem()
        title.title = "PalmList"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 32)!]
        return title
    }()
    
    var listItems: [ListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.register(ListItemCell.self, forCellReuseIdentifier: "cellID")
        view.backgroundColor = .white
        navigationItem.title = "PalmList"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAdd(_:)))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        listTableView.tableFooterView = UIView()
        setupTableView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! ListItemCell
//        cell.checkButton.isSelected = listItems[indexPath.row].isChecked
        cell.checkButton.isSelected = items[indexPath.section][indexPath.row].isChecked
//        cell.priorityButton.setTitle(listItems[indexPath.row].priorityLevel, for: .normal)
        cell.priorityLabel.text = items[indexPath.section][indexPath.row].priorityLevel
//        cell.itemLabel.text = listItems[indexPath.row].itemText
        cell.itemLabel.text = items[indexPath.section][indexPath.row].itemText
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = listTableView.cellForRow(at: indexPath) as! ListItemCell
        popoverCellIndex = indexPath
        let controller = PopoverViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 400)
        controller.priorityPassed = cell.priorityLabel.text!
        controller.textBox.text = cell.itemLabel.text!
        controller.priorityPassed = cell.priorityLabel.text!
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = cell
        presentationController.sourceRect = cell.bounds
        presentationController.permittedArrowDirections = [.up, .down]
        presentationController.backgroundColor = UIColor(r: 211, g: 221, b: 230)
        self.present(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = ListItem.createFetchRequest()
        request.returnsObjectsAsFaults = false
        
        var myItems: [ListItem] = []
        var tempItems: [[ListItem]] = [[], [], [], [], []]
        
        if let results = try? context.fetch(request) {
            for result in results {
                myItems.insert(result, at: 0)
                tempItems[Int(result.priorityLevel)! - 1].insert(result, at: 0)
            }
        }
//        context.delete(myItems[indexPath.row])
        context.delete(tempItems[indexPath.section][indexPath.row])
        
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
        
        items[indexPath.section].remove(at: indexPath.row)
        listTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func setupTableView() {
        view.addSubview(listTableView)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        listTableView.topAnchor.constraint(equalTo:view.safeTopAnchor).isActive = true
        listTableView.leftAnchor.constraint(equalTo:view.safeLeftAnchor).isActive = true
        listTableView.rightAnchor.constraint(equalTo:view.safeRightAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo:view.safeBottomAnchor).isActive = true
    }
    
    @objc func onAdd(_ sender: UIBarButtonItem) {
        
        let controller = AddItemViewController()
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 400)
        controller.delegate = self
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.barButtonItem = navigationItem.rightBarButtonItem
        presentationController.permittedArrowDirections = [.up, .down]
        presentationController.backgroundColor = UIColor(r: 211, g: 221, b: 230)
        self.present(controller, animated: true)
    }
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = ListItem.createFetchRequest()
        request.returnsObjectsAsFaults = false
        
        var priority = 0
        
        if let results = try? context.fetch(request) {
            for result in results {
                priority = Int(result.priorityLevel)!
                
                items[priority - 1].insert(result, at: 0)
            }
        }
        var z = 0
        var x = 0
        for i in items {
            x = 0
            for _ in items[z] {
                print(i[x].isChecked, i[x].priorityLevel, i[x].itemText)
                x += 1
            }
            z += 1
        }
    }
    
    func setChecked(cell: ListItemCell) {
        guard let indexPath = self.listTableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        let cell = listTableView.cellForRow(at: indexPath) as! ListItemCell
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = ListItem.createFetchRequest()
        request.returnsObjectsAsFaults = false
        
        var tempItems: [[ListItem]] = [[], [], [], [], []]
        var priorityInt = 0
        
        if let results = try? context.fetch(request) {
            for result in results {
                priorityInt = Int(result.priorityLevel)!
                tempItems[priorityInt - 1].insert(result, at: 0)
            }
        }
        
        if cell.checkButton.isSelected {
            cell.checkButton.isSelected = false
            tempItems[indexPath.section][indexPath.row].isChecked = false
        }
        else {
            cell.checkButton.isSelected = true
            tempItems[indexPath.section][indexPath.row].isChecked = true
        }
        
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
    }
    
    func popoverData(priority: String, itemText: String) {
        let cell = listTableView.cellForRow(at: popoverCellIndex) as! ListItemCell
        cell.priorityLabel.text = priority
        cell.itemLabel.text = itemText
        
        var isChecked: Bool
        
        switch cell.checkButton.isSelected {
        case true:
            isChecked = true
        case false:
            isChecked = false
        }
        
        let newIndexPath = IndexPath(row: 0, section: Int(priority)! - 1)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = ListItem.createFetchRequest()
        request.returnsObjectsAsFaults = false
        
        var tempItems: [[ListItem]] = [[], [], [], [], []]
        var priorityInt = 0
        
        if let results = try? context.fetch(request) {
            for result in results {
                priorityInt = Int(result.priorityLevel)!
                tempItems[priorityInt - 1].insert(result, at: 0)
            }
        }
        
        tempItems[popoverCellIndex.section][popoverCellIndex.row].priorityLevel = priority
        tempItems[popoverCellIndex.section][popoverCellIndex.row].itemText = itemText
        tempItems[popoverCellIndex.section][popoverCellIndex.row].isChecked = isChecked
        
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
        cell.isSelected = false
        items = [[], [], [], [], []]
        loadData()
        listTableView.moveRow(at: popoverCellIndex, to: newIndexPath)
    }
    
    func addItemData(priority: String, itemText: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let palmListItem = ListItem(context: context)
        
        palmListItem.isChecked = false
        palmListItem.priorityLevel = priority
        palmListItem.itemText = itemText
        
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
        
        let priorityInt = Int(priority)
        self.items[priorityInt! - 1].insert(palmListItem, at: 0)
        let indexPath = IndexPath(row: 0, section: priorityInt! - 1)
        self.listTableView.insertRows(at: [indexPath], with: .left)
    }
}
