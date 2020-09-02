//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Виталий on 02.09.2020.
//  Copyright © 2020 Виталий. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {

    var tasks: [Task] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let context = getContext()
        let fetchRequaest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequaest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let alerctController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (aaction) in
            let textField = alerctController.textFields?.first
            
            if let newTask = textField?.text {
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }
        
        alerctController.addTextField { _ in}
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in}
        alerctController.addAction(saveAction)
        alerctController.addAction(cancelAction)
        
        present(alerctController, animated: true, completion: nil)
    }
    
    // Get Context
    private func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Save Task to CoreData
    private func saveTask(withTitle title: String) {
          let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return}
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.insert(taskObject, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
            
        
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }

}
