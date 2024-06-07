//
//  DessertInformationTableViewController.swift
//  FetchReceipe
//
//  Created by Carlos Elizondo on 6/5/24.
//

import UIKit

class DessertInformationTableViewController: UITableViewController {
    
    
    
    var idMeal: String?
    var detailedMeal: MealsDetailed?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I am inside dessert infomration table view controller!")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 435
        tableView.reloadData()
        guard let idMeal = idMeal else { return print("guard returned idMeal") }
        print("idMeal: \(idMeal)")
        Task {
            do {
                detailedMeal = try await fetchDessert(idMeal: idMeal)
                guard let detailedMeal = detailedMeal else {return print("guard returned detailedMeal")}
                print("Successfully fetched detailedMeal:\n\n \(String(describing: detailedMeal))")
                tableView.reloadData()
            } catch {
                print ("Fetch mealInfo failed with error: \(error)")
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Class Constructors
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init?(coder: NSCoder, idMeal: String) {
        self.idMeal = idMeal
        super.init(coder: coder)
    }
    
    func fetchDessert(idMeal: String) async throws -> MealsDetailed {
        let partialURL = "https://themealdb.com/api/json/v1/1/lookup.php?i="
        let urlComponents = URLComponents(string: "\(partialURL)\(idMeal)")!
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        let jsonDecoder = JSONDecoder()
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MealsInfoError.itemsNotFound
        }
        //       let string = String(data: data, encoding: .utf8) {
        let mealDetailed = try jsonDecoder.decode(MealsDetailed.self, from: data)
        return mealDetailed
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let detailedMeal = detailedMeal?.mealsDetailedArray else { return 0}
        return detailedMeal.count
    }

    // Get custom cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dessertInformationCell", for: indexPath) as! detailedMealTableViewCell
        
        // Get the the meal at that specific indexPath
        guard let meal = detailedMeal?.mealsDetailedArray[indexPath.row] else { return cell }
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
    }
    */

}
