//
//  XmlTableViewController.swift
//  KC-JSONReader
//
//  Created by Kartheek chintalapati on 28/09/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//
/**************************************************************************************
 * In this file, XML parsing is done using GCD. fetchXmlData() provides               *
 * the data to parse. parser(didStartElement) is called when a start tag              *
 * is found. parser(didEndElement) is called when a end tag is found.                 *
 * parser(parseErrorOccurred) is called when error is occurred.                       *
 * Content from following links was referred for XML parsing:                         *
 * 1. http://leaks.wanari.com/2016/08/24/xml-parsing-swift/                           *
 * 2. http://ashishkakkad.com/2014/10/xml-parsing-in-swift-language-ios-10-xmlparser/ *
 **************************************************************************************/
import UIKit

class XmlTableViewController: UITableViewController, XMLParserDelegate {

    //MARK: - Variables
    var personData = [Person]() //instantiate a person
    var singlePerson = Person()
    var currentElement:String = ""
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
            fetchXmlData()
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User defined function for XML data
    func fetchXmlData()
    {
        
        let url:String = "http://faculty.cs.niu.edu/%7Ekrush/ios/client_list_xml.txt"
        let urlToSend: URL = URL(string: url)!
        
        // Parse the XML
        let parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self
        parser.parse()
        
        self.tableView.reloadData()
    }//end func
    
    //MARK: - Parsing functions
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
            singlePerson = Person()
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
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
