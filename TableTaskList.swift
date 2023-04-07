//
//  TableTaskList.swift
//  HM CoreData
//
//  Created by Dinar on 05.04.2023.
//

import UIKit

class TableTaskList: UITableViewController {
 
    private var taskList: [Task] = []
    private let cellId = "cellTaskList"

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Delete Task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    private func fetchData(){
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let task):
                self.taskList = task
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Save Task
    private func save(_ nameTask: String){
        StorageManager.shared.createTask(nameTask) { [weak self] task in
            self?.taskList.append(task)
            
            let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
            tableView.insertRows(at: [cellIndex], with: .automatic)
            
        }
        
    }
    
    //MARK: - Update Task
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        showUpdateAlert()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - ShowAlert
    private func showAlert(_ message: String, _ title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .destructive) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField() { textField in
            textField.placeholder = "New Task"
        }
        
        present(alert, animated: true)
    }
    
    
    private func showUpdateAlert(_ message: String, _ title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
    }
    
    

    
    

}
