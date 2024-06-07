//
//  ViewController.swift
//  FetchReceipe
//
//  Created by Carlos Elizondo on 5/31/24.
//

import UIKit

class ViewController: UIViewController {
    func fetchMeals() async throws -> Meals {
        let urlComponents = URLComponents(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        let jsonDecoder = JSONDecoder()
        guard let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 else {
            throw MealsInfoError.itemsNotFound
        }
    //       let string = String(data: data, encoding: .utf8) {
           let meals = try jsonDecoder.decode(Meals.self, from: data)
            return meals
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
}

