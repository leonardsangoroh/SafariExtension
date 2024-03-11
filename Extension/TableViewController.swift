//
//  TableViewController.swift
//  Extension
//
//  Created by Lee Sangoroh on 11/03/2024.
//

import UIKit

class TableViewController: UITableViewController {
    
    var scripts = [Script]()
    weak var delegate: ActionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "scriptCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    @objc func deleteAll (){
        UserDefaults.standard.removeObject(forKey: "Scripts")
        scripts.removeAll()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return scripts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scriptCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = scripts[indexPath.row].name ?? "Script not loaded."

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var script = scripts[indexPath.row]
        /// String(describing: ) is an initializer used to create a string representation of a given value, regardless of its type
        let ac = UIAlertController(title: "URL: \(String(describing: script.url!))", message: "\(String(describing: script.script!))" , preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Change the Scripts Name", style: .default, handler: { [weak self] _ in
            
            let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
            ac.addTextField(configurationHandler: nil)
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
                
                guard let newValue = ac?.textFields?[0].text else { return }
                script.name = newValue
                self?.delegate?.renameScript(newName: newValue, idx: indexPath)
                self?.refresh()
            }
            ac.addAction(submitAction)
            self?.present(ac, animated: true, completion: nil)
            
        }))
        
        ac.addAction(UIAlertAction(title: "Load the Script", style: .default, handler: { [weak self] _ in
            self?.delegate?.loadScript(fromScript: script.script)
            self?.navigationController?.popViewController(animated: true)
            
        }))
        
        ac.addAction(UIAlertAction(title: "Delete the Script", style: .default, handler: { [weak self] _ in
            self?.delegate?.deleteScript(idx: indexPath)
            self?.refresh()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refresh() {
        scripts = delegate?.getScripts() ?? scripts as! [Script]
        tableView.reloadData()
    }

}
