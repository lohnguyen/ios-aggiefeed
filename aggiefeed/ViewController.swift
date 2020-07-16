//
//  ViewController.swift
//  aggiefeed
//
//  Created by Long H. Nguyen on 7/14/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityTable: UITableView!
    
    var activities: [Activity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTable.dataSource = self
        activityTable.delegate = self
        
        process(link: "https://aggiefeed.ucdavis.edu/api/v1/activity/public?s=0?l=25")
        
    }
        
    func displayData() {
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        cell.textLabel!.text = activities[indexPath.row].title
        
        return cell
    }

    
    func process(link: String) {
        if let url = URL(string: link) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.activities = self.parseJSON(data: safeData)
                    self.displayData()
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> [Activity] {
        let decoder = JSONDecoder()
        
        do {
            /*
             * reference: parse JSON as an array
             * https://stackoverflow.com/questions/48023096/swift-jsondecoder-typemismatch-error
             */
            return try decoder.decode([Activity].self, from: data)
        } catch {
            print(error)
        }
        
        return []
    }
    
}
