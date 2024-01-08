//
//  ViewController.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/12/23.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var ancestorsLabel: UILabel!
    @IBOutlet weak var synonymsScientificNameLabel: UILabel!
    @IBOutlet weak var accordingToLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var agentsFullNameLabel: UILabel!
    
    var animalID = 0
    var animalInfo = [TaxonInfo]()
    var dataObjects = [DataInfo]()
    var hierarchy = Hierarchy(entry: Entry(name: ""), nameAccordingTo: [], ancestors: [])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMoreInfo()
         
    }
    
    func getMoreInfo() {
        Task {
            do {
                let animalInfoRequest = FetchEOLPages(searchID: String(animalID))
                let fetchedInfo = try await EOLAPIController.shared.sendRequest(animalInfoRequest)
                self.animalInfo = fetchedInfo.taxonConcept.taxon
                self.dataObjects = fetchedInfo.taxonConcept.dataObjects
                updateUI()
            } catch {
                print(error)
            }
        }
    }
    
    func updateUI() {
        let firstAnimalTaxon = animalInfo.first
        let firstDataObject = dataObjects.first
        let firstAgent = firstDataObject?.agents.first
        callHierarchy(with: firstAnimalTaxon!.id)
        
        agentsFullNameLabel.text = "\(firstAgent!.fullName) \(firstAgent!.role)"
        licenseLabel.text = firstDataObject!.license
        licenseLabel.textColor = .tintColor
        
        Task {
            let imageRequest = ImageAPIRequest(url: firstDataObject!.imageURL)
            self.imageView.image = try await EOLAPIController.shared.sendRequest(imageRequest)
        }
    }
    
    func callHierarchy(with id: Int) {
        Task {
            do {
                let hierarchyRequest = FetchEOLHierarchy(searchID: String(id))
                let fetch = try await EOLAPIController.shared.sendRequest(hierarchyRequest)
                self.hierarchy = fetch
                print(hierarchy)
                updateUIPart2()
            } catch {
                print(error)
            }
        }
    }
    
    func updateUIPart2() {
        synonymsScientificNameLabel.text = hierarchy.entry.name
        var ancestorString = ""
        
        for each in hierarchy.ancestors {
            ancestorString += "\n\(each.name)"
        }
        
        ancestorsLabel.text = ancestorString
        accordingToLabel.text = hierarchy.nameAccordingTo.first
        
    }
    
}

