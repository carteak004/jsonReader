//
//  ViewController.swift
//  jsonReader
//
//  Created by Kartheek chintalapati on 26/09/17.
//  Copyright © 2017 Kartheek Chintalapati. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {

    var personData = [person]() //instantiate a person
    var singlePerson = person()
    var currentElement:String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        let queueX = DispatchQueue(label: "edu.niu.cs.queueX")
        switch segmentedControl.selectedSegmentIndex
        {
        case 1:
            personData = [person]()
            fetchJsonData()
            //DispatchQueue.main.async {
              //  self.tableView.reloadData()
            //}
            
        case 0:
            personData = [person]()
            queueX.sync {
            fetchXmlData()
            }
        default:
            queueX.sync {
                //fetchJsonData()
                fetchXmlData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchJsonData()
        //fetchXmlData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User defined functions
    
    func fetchJsonData() {
        
        
        //fetching Json data
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
                                
                                self.singlePerson.name = name
                                self.singlePerson.profession = profession
                                self.singlePerson.dob = dob
                                self.singlePerson.children = children
                                
                                self.personData.append(self.singlePerson)
                                
                                print("\(self.singlePerson.name),\(self.singlePerson.profession), \(self.singlePerson.dob), \(self.singlePerson.children)")
                                
                            }//end if
                            
                        }//end for loop
                        
                    }//end if
                    
                    //if you are using a table view, you would reload the data
                    //self.tableView.reloadData()
                    
                }//end do
                    
                catch {
                    
                    print(error)
                    
                }//end catch
                
            }//end if
            
        }//end getdatasession
        
        task.resume()
    }
    /******************************************************************************************************/
    func fetchXmlData()
    {
        //personData = [person]()
        
        let url:String = "http://faculty.cs.niu.edu/%7Ekrush/ios/client_list_xml.txt"
        let urlToSend: URL = URL(string: url)!
        // Parse the XML
        let parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self
        parser.parse()
        tableView.reloadData()
    }//end func
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        
        if(elementName=="person")
        {
            if let name = attributeDict["name"], let dob = attributeDict["dob"], let profession = attributeDict["profession"]
            {
                singlePerson.name = name
                singlePerson.dob = dob
                singlePerson.profession = profession
            }
        }
        
        if(elementName=="child")
        {
            if let name = attributeDict["name"]
            {
                singlePerson.children.append(name)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        
        if(elementName=="person")
        {
            personData.append(singlePerson)
            singlePerson = person()
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
    /******************************************************************************************************/
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
