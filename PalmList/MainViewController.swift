//
//  MainViewController.swift
//  PalmList
//
//  Created by Timothy Waters on 1/26/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListItemCellDelegate {
    
    let listTableView = UITableView()
    let testData: [String] = ["Test 1", "Test 2", "Test 3", "Test 4", "Test 5"]
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
//        saveDate()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! ListItemCell
        cell.checkButton.isSelected = listItems[indexPath.row].isChecked
        cell.itemLabel.text = listItems[indexPath.row].itemText
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = ListItem.createFetchRequest()
        request.returnsObjectsAsFaults = false
        
        var items: [ListItem] = []
        
        if let results = try? context.fetch(request) {
            for result in results {
                items.insert(result, at: 0)
            }
        }
        context.delete(items[indexPath.row])
        
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
        
        listItems.remove(at: indexPath.row)
        listTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func setupTableView() {
        view.addSubview(listTableView)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        
        listTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        listTableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        listTableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
            palmListItem.priorityLevel = 1
            palmListItem.itemText = itemText
            
            do {
                try context.save()
            }
            catch let err {
                print(err)
            }
            
            self.listItems.insert(palmListItem, at: 0)
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
    
    func saveDate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let palmListItem = ListItem(context: context)
        
        palmListItem.isChecked = false
        palmListItem.priorityLevel = 5
        palmListItem.itemText = "Things"
        
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
    }
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = ListItem.createFetchRequest()
        request.returnsObjectsAsFaults = false
        
        if let results = try? context.fetch(request) {
            for result in results {
                listItems.insert(result, at: 0)
            }
        }
        
        for i in listItems {
            print(i.isChecked, i.priorityLevel, i.itemText)
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
        
        var items: [ListItem] = []
        
        if let results = try? context.fetch(request) {
            for result in results {
                items.insert(result, at: 0)
            }
        }
        
        if cell.checkButton.isSelected {
            cell.checkButton.isSelected = false
            items[indexPath.row].isChecked = false
            //            listItems[indexPath.row].isChecked = false
        }
        else {
            cell.checkButton.isSelected = true
            items[indexPath.row].isChecked = true
            //            listItems[indexPath.row].isChecked = true
        }
        
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
    }
}
