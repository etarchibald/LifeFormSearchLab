//
//  LifeFormTableViewController.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import UIKit

class LifeFormTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var animals = [SearchAnimal]()
    private var animalID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getAnimals() {
        tableView.reloadData()
        
        let searchAnimalName = searchBar.text ?? ""
        
        guard !searchAnimalName.isEmpty else { return }
        Task {
            do {
                let animalsToSearch = EOLSearch(searchTerm: searchAnimalName)
                let fetchedAnimals = try await EOLAPIController.shared.sendRequest(animalsToSearch)
                await MainActor.run {
                    self.animals = fetchedAnimals
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
            
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Animal", for: indexPath) as! LifeFormTableViewCell
        
        let animal = animals[indexPath.row]

        cell.updateUI(with: animal)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animal = animals[indexPath.row]
        animalID = animal.id
        self.performSegue(withIdentifier: "toAnimalDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnimalDetail" {
            let vc = segue.destination as! ViewController
            vc.animalID = animalID
        }
    }

}

extension LifeFormTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getAnimals()
    }
}
