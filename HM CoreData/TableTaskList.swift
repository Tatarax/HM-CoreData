//
//  TableTaskList.swift
//  HM CoreData
//
//  Created by Dinar on 05.04.2023.
//

import UIKit

class TableTaskList: UITableViewController {
 
    //MARK: - Private properties
    private var taskList: [Task] = []
    private let cellId = "cellTaskList"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            displayP3Red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
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
    
    @objc private func addTask() {
        showAlert("New Task", message: "What?")
    }
    
    // MARK: - Delete Task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let task = taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.deleteTask(task)
        }
    }
    
    // MARK: - Fetch Data
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
        showUpdateAlert("Update task", "Ok, What?")
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - ShowAlerts
    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .destructive) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField() { textField in
            textField.placeholder = "New Task"
        }
        
        present(alert, animated: true)
    }
    
    // Думаю ошибка тут. мне тут нужно взять уже сохраненной значение и поменять его на новое но не могу догадаться как это сделать.
    private func showUpdateAlert(_ message: String, _ title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Save", style: .destructive) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else {return}
          
         //   StorageManager.shared.update(<#Task#>,  task)
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        alert.addTextField() { textField in
            textField.placeholder = "Update Task"
        }
        
        present(alert, animated: true)
    }
    
    

    
    

}
