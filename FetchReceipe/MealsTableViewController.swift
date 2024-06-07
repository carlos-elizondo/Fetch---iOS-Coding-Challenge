//
//  MealsTableViewController.swift
//  FetchRecipe
//
//  Created by Carlos Elizondo on 6/3/24.
//

import UIKit

// Converts the received URL into a UIImage object.
class ImageDownloader {
    static func downloadImage(_ urlString: String, completion: ((_ _image: UIImage?, _ urlString: String?) -> ())?) {
       guard let url = URL(string: urlString) else {
          completion?(nil, urlString)
          return
      }
      URLSession.shared.dataTask(with: url) { (data, response,error) in
         if let error = error {
            print("error in downloading image: \(error)")
            completion?(nil, urlString)
            return
         }
         guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
            completion?(nil, urlString)
            return
         }
         if let data = data, let image = UIImage(data: data) {
            completion?(image, urlString)
            return
         }
         completion?(nil, urlString)
      }.resume()
   }
}

class MealsTableViewController: UITableViewController {
    @IBOutlet weak var loadMainRecipesActivityIndicator: UIActivityIndicatorView!
    
    
    var meals: Meals?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            do {
                meals = try await fetchMeals()
                guard let mealsFetched = meals else { return }
                meals = sortedMealsAlphabetically(mealList: mealsFetched)
//                print("Successfully fetched meals:\n\n \(meals)")
                tableView.reloadData()
            } catch {
                print ("Fetch mealInfo failed with error: \(error)")
            }
        }
        
        // Giving time for images to download and load
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadMainRecipesActivityIndicator.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // Tires to fetch the recipes from the 1st endpoint.
    func fetchMeals() async throws -> Meals {
        let urlComponents = URLComponents(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        let jsonDecoder = JSONDecoder()
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MealsInfoError.itemsNotFound
        }
        let meals = try jsonDecoder.decode(Meals.self, from: data)
        return meals
    }
    
    func sortedMealsAlphabetically(mealList: Meals) -> Meals {
        let sortedMealList = mealList.mealsArray.sorted {$0.nameOfMeal < $1.nameOfMeal}
        return Meals(mealsArray: sortedMealList)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let meals = meals else { return 0}
//        print("\n\nMeals.count: \(meals.mealsArray.count)\n\n")
        return meals.mealsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealsCell", for: indexPath) as! dessertTableViewCell
        
        // Get the the meal at that specific indexPath
        guard let meal = meals?.mealsArray[indexPath.row] else { return cell }
        
        // Configure the cell...
        cell.update(meal: meal)
        return cell
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
//        segue.destination.
    }
    */

    @IBSegueAction func dessertToRetrieve(_ coder: NSCoder, sender: Any?) -> DessertInformationTableViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            guard let dessertToRetrieveIdMeal = meals?.mealsArray[indexPath.row].idMeal else {
                return DessertInformationTableViewController(coder: coder)
            }
            return DessertInformationTableViewController(coder: coder, idMeal: dessertToRetrieveIdMeal)
        } else {
            return DessertInformationTableViewController(coder: coder)
        }
    }
}
