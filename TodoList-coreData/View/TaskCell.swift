//
//  TaskCell.swift
//  TodoList-coreData
//
//  Created by Akel Barbosa on 13/07/22.
//

import UIKit

class TaskCell: UITableViewCell {

    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameTask: UILabel = {
        let label = UILabel()
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
            nameTask.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 5),
            nameTask.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameTask.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(button)
        contentView.addSubview(nameTask)
        contraints()
 
        
    }
    
    func configure(Task: Tasks){
        nameTask.text = Task.name
        
        if Task.done == false {
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            nameTask.textColor = isDarkMode ? .white: .black

        } else {
            let circle = UIImage(systemName: "circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            nameTask.textColor = .systemGray
            button.setImage(circle, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
