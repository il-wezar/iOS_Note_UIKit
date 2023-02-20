//
//  NotesViewController.swift
//  iOS2_Note_0.2(UIKit)
//
//  Created by Illia Wezarino on 06.02.2023.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    var models = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        models = CoreDataHelper.retrieveNote()
        setupSubviews()
    }
    
    func setupSubviews() {
        view.backgroundColor = .white
        view.frame = view.bounds
        title = "Notes"
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
//        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonOnNavigation))

        models = models.sorted(by: {$0.time?.compare($1.time!) == .orderedDescending })
    }

    @objc func rightButtonOnNavigation() {
        let vc = NoteViewController()
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - Table view data source and delegate

extension NotesTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(models)
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier,
                                                 for: indexPath) as! TableViewCell
        
        tableView.rowHeight = 120
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy 'at' HH:mm:ss"
        
        cell.titleOfNote.text = models[indexPath.row].title
        cell.subtitleOfNote.text = models[indexPath.row].text
        cell.dateOfNote.text = dateFormatter.string(from: models[indexPath.row].time ?? Date())
        cell.locationLabel.text = models[indexPath.row].location
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NoteViewController()
        vc.titleOfNote.text = models[indexPath.row].title
        vc.textOfNote.text = models[indexPath.row].text
        vc.locationString = models[indexPath.row].location
        vc.indexPath = indexPath
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Warning",
                                      message: "Are you sure you want to delete this note?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { _ in
//            self.models.remove(at: indexPath.row)
            let noteToDelete = self.models[indexPath.row]
            CoreDataHelper.deleteNote(note: noteToDelete)

            self.models = CoreDataHelper.retrieveNote()
            tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))

        if editingStyle == .delete {
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension NotesTableViewController: NotesDelegate {
    func update(title: String, text: String, indexPath: IndexPath?, location: String?) {
        if let indexPath = indexPath {
            models[indexPath.row].title = title
            models[indexPath.row].text = text
            models[indexPath.row].time = Date()
            models[indexPath.row].location = location
            
        } else if title != "" {
            let note = CoreDataHelper.newNote()
            note.title = title
            note.text = text
            note.time = Date()
            note.location = location
            
            models.append(note)
        } else { return }
        
        models = models.sorted(by: {$0.time?.compare($1.time!) == .orderedDescending })
        CoreDataHelper.saveNote()
        tableView.reloadData()
    }
}
