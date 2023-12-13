//
//  LifeFormTableViewController.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import UIKit

class LifeFormTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var animals = [SearchAnimal]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getAnimals() {
        tableView.reloadData()
        
        let searchAnimalName = searchBar.text ?? ""
        
        if !searchAnimalName.isEmpty {
            Task {
                do {
                    let fetchedAnimals = try await EOLAPIController.shared.fetchEOLSearch(with: searchAnimalName)
                    self.animals = fetchedAnimals
                } catch {
                    print(error)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Animal", for: indexPath) as! LifeFormTableViewCell
        
        let animal = animals[indexPath.row]

        cell.updateUI(with: animal)

        return cell
    }

}

extension LifeFormTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getAnimals()
    }
}
