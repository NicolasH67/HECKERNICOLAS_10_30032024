//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 02/04/2024.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeTableViewCellUILabel: UILabel!
    
    @IBOutlet weak var recipeContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
