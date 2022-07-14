//
//  ViewController.swift
//  TodoList-coreData
//
//  Created by Akel Barbosa on 13/07/22.
//

import UIKit

class ViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [Activities]()

    private let listActivities: UITableView = {
        let table = UITableView()
        table.register(ActivityCell.self, forCellReuseIdentifier: "ActivityCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let addTitleActivity: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func addActivity() {

        let addCategorie = UIAlertController(title: "Actividad", message: "Ingrese el nombre de la activadad", preferredStyle: .alert)
        
        addCategorie.addTextField { field in
            field.placeholder = "Agregue la actividad"
        }
        
        addCategorie.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: {_ in }))
        
        addCategorie.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { action in
            guard let fields = addCategorie.textFields?.first, let text = fields.text, !text.isEmpty else { return}
            
            self.createActivity(name: text)
            

        } ))
        
        present(addCategorie, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .systemBackground
        title = "Lista de actividades"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        let buttonAdd = UIImage(systemName: "plus.circle")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonAdd, style: .done, target: self, action: #selector(addActivity))
    }
    
    func constraintsElemen() {
        NSLayoutConstraint.activate([
            listActivities.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            listActivities.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listActivities.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            listActivities.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.addSubview(listActivities)
        getAllActivities()
        listActivities.dataSource = self
        listActivities.delegate = self
        
        constraintsElemen()
    }
    
    func getAllActivities() {
        
        do {
            models = try context.fetch(Activities.fetchRequest())
            DispatchQueue.main.async {
                self.listActivities.reloadData()
            }
        } catch {
            print("Error al guardar actividad")
        }
    }
    
    func createActivity(name: String) {
        let newActivity = Activities(context: context)
        newActivity.name = name
        
        do {
            try context.save()
            getAllActivities()
        } catch {
            print("Error al guardar actividad")
        }
        
    }
    
    
    func deleteActivity(activity: Activities) {
        context.delete(activity)
        do {
            try context.save()
            getAllActivities()
        } catch {
            print("Error al guardar actividad")
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as? ActivityCell else { return UITableViewCell()}
        
        cell.configure(activity: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            deleteActivity(activity: models[indexPath.row])

        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let listTaskView = ListTaskViewController()
        listTaskView.activity = models[indexPath.row]
        navigationController?.pushViewController(listTaskView, animated: true)
        
    }
    
    
}
