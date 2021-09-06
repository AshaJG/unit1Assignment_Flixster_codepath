//
//  MoviesViewController.swift
//  flixster
//
//  Created by Ashley Jo-ann Grant on 9/4/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    @IBOutlet weak var tableView: UITableView!
    // Get the array of movies
    var movies = [[String:Any]]() //creating an array of dictionaries

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //step3
        tableView.dataSource = self
        tableView.delegate = self
        
        print("Hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //casting the info
                self.movies = dataDictionary["results"] as! [[String:Any]]  //Store the movies in a property to use elsewhere
                //reloads the data to be displayed// Reload your table view data
                self.tableView.reloadData()
                print (dataDictionary)
             }
        }
        task.resume()

        // Do any additional setup after loading the view.
    }
    //step2
    //the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    //the number of cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //re using cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row] //gets the movies
        let title = movie["title"] as! String //gets the title of the movie
        let synopsis = movie["overview"] as! String
        //gives u access to the outlets
        cell.titleLabel.text = title
        cell.synopsisLabel.text=synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl=URL(string: baseUrl + posterPath)
        //allows the images to download
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        
        
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
