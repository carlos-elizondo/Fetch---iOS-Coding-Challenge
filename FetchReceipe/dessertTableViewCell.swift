//
//  dessertTableViewCell.swift
//  FetchReceipe
//
//  Created by Carlos Elizondo on 6/7/24.
//

import UIKit

class dessertTableViewCell: UITableViewCell {

    @IBOutlet weak var dessertImageView: UIImageView!
    @IBOutlet weak var dessertNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(meal: Meal) {
        ImageDownloader.downloadImage(meal.mealStringURLImage) {
                image, urlString in
                if let imageObject = image {
                    // performing UI operation on main thread
                    DispatchQueue.main.async {
                        self.dessertImageView.image = imageObject
                        self.dessertNameLabel.text = meal.nameOfMeal
                    }
                }
            }
    }
}
