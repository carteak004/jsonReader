//
//  jsonTableViewController.swift
//  KC-JSONReader
//
//  Created by Kartheek chintalapati on 28/09/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

/*************************************************************************
 * In this file, JSON data is parsed using GCD. Json Serialisation       *
 * is implemented in the background queue. Some of the data is passed to *
 * detail view controller.                                               *
 *************************************************************************/
import UIKit

class jsonTableViewController: UITableViewController {

    //MARK: - Variables
    var personData = [Person]()
    var inactiveQueue:DispatchQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //activating queue
        if let queue = inactiveQueue {
            queue.activate()
        }
        
        //background queue
        let queueX = DispatchQueue(label: "edu.niu.cs.queueX")
        
        queueX.sync {
            fetchJsonData()
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    //MARK: - User defined function for JSON data
    func fetchJsonData()
    {
        
        let api_url = URL(string: "http://faculty.cs.niu.edu/%7Ekrush/ios/client_list_json.txt") //create URL variable
        let urlRequest = URLRequest(url: api_url!) //create URL request
        
        //submit a request to JSON Data
        let task = URLSession.shared.dataTask(with: urlRequest)
        {
            (data,response,error) in
            //if there is an error, print it and do not continue
            if error != nil {
                print(error!)
                return
            }
            
            //if there is no error, fetch json content
            if let content = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    //fetch only client data
                    if let clientJson = jsonObject["clients"] as? [[String:AnyObject]] {
                        for item in clientJson
                        {
                            if let name = item["name"] as? String, let profession = item["profession"] as? String, let dob = item["dob"] as? String, let children = item["children"] as? [String]
                            {
                                let singlePerson = Person()
                                singlePerson.name = name
                                singlePerson.dob = dob
                                singlePerson.profession = profession
                                singlePerson.children = children
 
                                self.personData.append(singlePerson)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return personData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)

        // Configure the cell...
        let clientData = personData[indexPath.row]
        
        cell.textLabel?.text = clientData.name
        cell.detailTextLabel?.text = clientData.profession
        
        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DETAIL"
        {
            let detailVC = segue.destination as! DetailViewController
            
            //prepare data to send over segue
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                let clientList:Person = personData[indexPath.row]
                
                detailVC.sentDob = clientList.dob
                detailVC.sentChildren = clientList.children
                detailVC.sentProfession = clientList.profession
                
                detailVC.title = clientList.name
            }
        }
    }

}
