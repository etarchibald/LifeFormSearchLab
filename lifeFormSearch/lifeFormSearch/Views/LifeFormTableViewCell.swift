//
//  LifeFormTableViewCell.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import UIKit

class LifeFormTableViewCell: UITableViewCell {

    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var animalContentLabel: UILabel!
    
    func updateUI(with animal: SearchAnimal) {
        detailTitleLabel.text = animal.title
        animalContentLabel.text = animal.content
    }

}
