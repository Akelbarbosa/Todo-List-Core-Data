//
//  ListTaskViewController.swift
//  TodoList-coreData
//
//  Created by Akel Barbosa on 13/07/22.
//

import UIKit

class ListTaskViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [Tasks]()
    var activity: Activities?
    
    private let listTask: UITableView = {
        let table = UITableView()
        table.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    @objc func addTasks() {
    
        let addTask = UIAlertController(title: "Tarea", message: "Ingrese el nombre de la tarea a realizar", preferredStyle: .alert)
        
        addTask.addTextField { field in
            field.placeholder = "Agregue la tarea"
        }
        
        addTask.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: {_ in }))
        
        addTask.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { action in
            guard let fields = addTask.textFields?.first, let text = fields.text, !text.isEmpty else { return}
            self.createTask(name: text, done: false)


        } ))
        
        present(addTask, animated: true)
    }
    
    func setup(){
        view.backgroundColor = .systemYellow
        title = activity?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Agregar" , style: .done, target: self, action: #selector(addTasks))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getAllTask()
        listTask.dataSource = self
        listTask.delegate = self
        view.addSubview(listTask)
        listTask.frame = view.bounds
    }
    
    func createTask(name: String, done: Bool) {
        let newTask = Tasks(context: context)
        newTask.name = name
        newTask.done = done
        
        activity?.addToTasks(newTask)
        
        do {
            try context.save()
            getAllTask()

        } catch {
            print("Error al guardar actividad")
        }
        
    }
    
    
    func getAllTask() {
        
        do {
            let task = try context.fetch(Tasks.fetchRequest())
            models = task.filter({
                $0.activity?.name == self.activity?.name
            })

            DispatchQueue.main.async {
                self.listTask.reloadData()
            }
        } catch {
            print("Error al obtener tareas")
        }
        
    }
    
    func updateStateTask(task: Tasks,state: Bool) {
        task.done = state
        
        do {
            try context.save()
            getAllTask()

        } catch {
            print("Error al actualizar")
        }
        
    }
    
    func deleteTask(task: Tasks) {
        context.delete(task)
        do {
            try context.save()
            getAllTask()
        } catch {
            print("Error al eliminar tarea")
        }
    }

}

extension ListTaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {return UITableViewCell()}
   
        cell.configure(Task: models[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = models[indexPath.row]
        let state = !task.done
        updateStateTask(task: task, state: state)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            deleteTask(task: models[indexPath.row])

        }
    }
    
    
    
        
}
