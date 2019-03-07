//
//  MainViewController.swift
//  PalmList
//
//  Created by Timothy Waters on 1/26/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListItemCellDelegate, PriorityLevelDelegate {
    
    let listTableView = UITableView()
    
    let sectionArray = ["Priority 1", "Priority 2", "Priority 3", "Priority 4", "Priority 5"]
    
    var items: [[ListItem]] = [[], [], [], [], []]
    
    var popoverCellIndex = IndexPath()
    
    var navBarTitle: UINavigationItem = {
        let title = UINavigationItem()
        title.title = "PalmList"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "ChalkDuster", size: 32)!]
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
        cell.priorityButton.setTitle(items[indexPath.section][indexPath.row].priorityLevel, for: .normal)
//        cell.itemLabel.text = listItems[indexPath.row].itemText
        cell.itemLabel.text = items[indexPath.section][indexPath.row].itemText
        cell.delegate = self
        
        return cell
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
        
//        listItems.remove(at: indexPath.row)
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
        let alertController = UIAlertController(title: "PalmList", message: "Add an item to your list", preferredStyle: .alert)
        
        alertController.addTextField { (itemTF) in itemTF.placeholder = "Your item goes here" }
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            guard let itemText = alertController.textFields?.first?.text else {return}
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let palmListItem = ListItem(context: context)
            
            palmListItem.isChecked = false
            palmListItem.priorityLevel = "1"
            palmListItem.itemText = itemText
            
            do {
                try context.save()
            }
            catch let err {
                print(err)
            }
            
//            self.listItems.insert(palmListItem, at: 0)
            self.items[0].insert(palmListItem, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.listTableView.insertRows(at: [indexPath], with: .left)
        }
        
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) /* {
         (action:UIAlertAction!) in print("Cancel button tapped"); // Uncomment to make Cancel button do stuff
         } */
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
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
                
//                listItems.insert(result, at: 0)
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
        
//        var myItems: [ListItem] = []
        var tempItems: [[ListItem]] = [[], [], [], [], []]
        
        if let results = try? context.fetch(request) {
            for result in results {
//                myItems.insert(result, at: 0)
                tempItems[indexPath.section].insert(result, at: 0)
            }
        }
        
        if cell.checkButton.isSelected {
            cell.checkButton.isSelected = false
//            myItems[indexPath.row].isChecked = false
            tempItems[indexPath.section][indexPath.row].isChecked = false
            //            listItems[indexPath.row].isChecked = false
        }
        else {
            cell.checkButton.isSelected = true
//            myItems[indexPath.row].isChecked = true
            tempItems[indexPath.section][indexPath.row].isChecked = true
            //            listItems[indexPath.row].isChecked = true
        }
        
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
    }
    
    func popoverDisplay(cell: ListItemCell) {
        guard let indexPath = self.listTableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        popoverCellIndex = indexPath
        let cell = listTableView.cellForRow(at: indexPath) as! ListItemCell
        
        let controller = PopoverViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 80)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = cell
        presentationController.sourceRect = cell.bounds
        presentationController.permittedArrowDirections = [.up, .down]
        presentationController.backgroundColor = UIColor(r: 0, g: 84, b: 147)
        self.present(controller, animated: true)
    }
    
    func setPriorityLevel(level: String) {
        let indexPath = popoverCellIndex
        let fromIndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
        let toIndexPath = IndexPath(row: 0, section: Int(level)! - 1)

        let cell = listTableView.cellForRow(at: indexPath) as! ListItemCell
        cell.priorityButton.setTitle(level, for: .normal)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = ListItem.createFetchRequest()
        request.returnsObjectsAsFaults = false


//        if let results = try? context.fetch(request) {
//            for result in results {
//                items[Int(level)! - 1].insert(result, at: 0)
//            }
//        }
        
        var priority = 0
        
        if let results = try? context.fetch(request) {
            for result in results {
                priority = Int(result.priorityLevel)!
                
                //                listItems.insert(result, at: 0)
                items[priority - 1].insert(result, at: 0)
            }
        }
        
        let tempItem = items[fromIndexPath.section][fromIndexPath.row]
        
        items[fromIndexPath.section].remove(at: fromIndexPath.row)
        print("1. Worked")
        
        items[toIndexPath.section].insert(tempItem, at: toIndexPath.row)
        print("2. Worked")
        
        items[toIndexPath.section][toIndexPath.row].priorityLevel = level
        print("3. Worked")

        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
        print("4. Worked")
        
        listTableView.moveRow(at: fromIndexPath, to: toIndexPath)
        
        
        print("5. Worked")
    }
}
