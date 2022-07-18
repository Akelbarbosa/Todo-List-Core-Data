//
//  TaskCell.swift
//  TodoList-coreData
//
//  Created by Akel Barbosa on 13/07/22.
//

import UIKit

class TaskCell: UITableViewCell {
    
    public var taskForCell: Tasks?
    private var taskToMakeChange: Tasks?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameTask: UITextField = {
        let label = UITextField()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func contraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: 40),
            
            nameTask.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameTask.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 2),
            nameTask.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameTask.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.endEditing(true)
        button.addTarget(self, action: #selector(taskMake), for: .touchUpInside)
        nameTask.delegate = self
        contentView.addSubview(button)
        contentView.addSubview(nameTask)
        contraints()

        
        
    }

    @objc func taskMake() {
        let statusTask = taskForCell?.done
        taskForCell?.done = !statusTask!
        configButton(task: taskForCell!)
        taskToSave()
            
    }
    
    func configure(Task: Tasks){
        nameTask.text = Task.name
        configButton(task: Task)

    }

    func configButton(task: Tasks) {
        if task.done == false {
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            nameTask.textColor = isDarkMode ? .white: .black
            nameTask.isUserInteractionEnabled = true

        } else {
            let circle = UIImage(systemName: "circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            nameTask.textColor = .systemGray
            button.setImage(circle, for: .normal)
            nameTask.isUserInteractionEnabled = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskCell {
    func taskToEdit(){
        do {
            let taskSaved = try context.fetch(Tasks.fetchRequest())
            taskToMakeChange = taskSaved.filter({
                $0.name == self.taskForCell?.name
            }).first

        } catch {
            print("Error al buscar")
        }
    }
    
    
    public func updateNameTask() {
        guard let fields = nameTask.text, !fields.isEmpty else { return print("esta vacio")}
        taskForCell?.name = fields
        taskToSave()
        
    }
    
    func taskToSave() {
        do {
            try context.save()
        } catch {
            print("Error al guardar")
        }
    }
    
}

extension TaskCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let fields = textField.text, !fields.isEmpty else {return}
        updateNameTask()

    }
}


