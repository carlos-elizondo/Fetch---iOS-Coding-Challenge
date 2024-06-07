//
//  detailedMealTableViewCell.swift
//  FetchReceipe
//
//  Created by Carlos Elizondo on 6/6/24.
//

import UIKit

class detailedMealTableViewCell: UITableViewCell {

    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var IngredientsTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(meal: MealDetailed) {
        if let strMealThumb = meal.strMealThumb {
            ImageDownloader.downloadImage(strMealThumb) {
                image, urlString in
                if let imageObject = image {
                    // performing UI operation on main thread
                    DispatchQueue.main.async {
                        self.mealImageView.image = imageObject
                    }
                }
            }
        }
        mealNameLabel.text = meal.strMeal
        instructionsTextView.text = meal.strInstructions
        IngredientsTextView.text = getIngredientsAndMeasurements(meal: meal)
    }
    
    // Function retrieves the attributes for the non-null ingredients & measurements
    // Then it creates a dictionary of each with their values
    // It returns a string as such: *(bullet point) ingredient measurement
    func getIngredientsAndMeasurements(meal: MealDetailed) -> String {
        let mirror = Mirror(reflecting: meal)
        var ingredientsDict = [String: String]()
        var measurementsDict = [String: String]()
        var ingredientString = ""
        
        for child in mirror.children {
            if let propertyName = child.label, let propertyValue = child.value as? String {
                if propertyValue != "" && propertyValue != " " {
                        if propertyName.hasPrefix("strIngredient") {
                            ingredientsDict[propertyName] = propertyValue
                        }
                        if propertyName.hasPrefix("strMeasure") {
                            measurementsDict[propertyName] = propertyValue
                        }
                }
            }
        }
        let sortedIngredientsArray = ingredientsDict.sorted(by: <)
        var sortedMeasurementsArray = measurementsDict.sorted(by: <)
        for (key, ingredientValue) in sortedIngredientsArray {
            ingredientString += "\u{2022} \(ingredientValue) "
            for (key, measurementValue) in sortedMeasurementsArray {
                ingredientString += "\(measurementValue)\n"
                sortedMeasurementsArray.remove(at: 0)
                break
            }
        }
        return ingredientString
    }

}
