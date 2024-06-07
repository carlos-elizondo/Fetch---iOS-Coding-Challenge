//
//  Meals.swift
//  FetchReceipe
//
//  Created by Carlos Elizondo on 5/31/24.
//

import Foundation
import UIKit

struct Meals: Codable {
    var mealsArray: [Meal]
    
    enum CodingKeys: String, CodingKey {
        case mealsArray = "meals"
    }
}

struct Meal: Codable {
    var nameOfMeal: String
    var mealStringURLImage: String
    var idMeal: String
    var mealImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case nameOfMeal = "strMeal"
        case mealStringURLImage = "strMealThumb"
        case idMeal
    }
}

enum MealsInfoError: Error, LocalizedError {
    case itemsNotFound
}
