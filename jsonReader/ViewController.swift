//
//  ViewController.swift
//  jsonReader
//
//  Created by Kartheek chintalapati on 26/09/17.
//  Copyright © 2017 Kartheek Chintalapati. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var personData = [person]() //instantiate a person
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            fetchJsonData()
        case 1:
            fetchXmlData()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJsonData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User defined functions
    
    func fetchJsonData() {
        //fetching fox news latest articles
        let api_url = URL(string: "http://faculty.cs.niu.edu/%7Ekrush/ios/client_list_json.txt")
        
        //create a URL request with the API address
        let urlRequest = URLRequest(url: api_url!)
        
        //submit a request to the Json data
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data,response,error) in
            //if there is an error, print it and do not continue
            if error != nil {
                print(error!)
                return
            }//end if
            
            //if there is no error, fetch json formatted content
            if let content = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    //Fetch only the articles
                    if let clientssJson = jsonObject["clients"] as? [[String:AnyObject]] {
                        for item in clientssJson {
                            if let name = item["name"] as? String, let profession = item["profession"] as? String, let dob = item["dob"] as? String, let children = item["children"] as? [String] {
                                
                                print("*****MARK: BEGIN*****")
                                print(name, profession, dob, children)
                                print("*****MARK: END*****")
                                
                                self.personData.append(person(name: name, profession: profession, dob: dob, children: children))
                                
                            }//end if
                            
                        }//end for loop
                        
                    }//end if
                    
                    //if you are using a table view, you would reload the data
                    self.tableView.reloadData()
                    
                }//end do
                    
                catch {
                    
                    print(error)
                    
                }//end catch
                
            }//end if
            
        }//end getdatasession
        
        task.resume()
    }
    
    func fetchXmlData()
    {
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return personData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! TableViewCell
        
        let clientData = personData[indexPath.row]
        
        cell.nameLabel.text = clientData.name
        cell.professionLabel.text = clientData.profession
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
