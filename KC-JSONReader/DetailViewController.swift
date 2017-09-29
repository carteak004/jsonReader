//
//  DetailViewController.swift
//  KC-JSONReader
//
//  Created by Kartheek chintalapati on 28/09/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

/*************************************************************************
 * In this VC, parsed data is displayed. If there is no children, the    *
 * table view will be hidden and a label is displayed saying no children.*
 *************************************************************************/

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sentDob:String!
    var sentProfession:String!
    var sentChildren:[String]!
    var childString:String!
    
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var childLabel: UILabel!
    @IBOutlet weak var childTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        professionLabel.text = sentProfession
        dobLabel.text = sentDob
        
        childLabel.isHidden = true
        childTableView.isHidden = true
        
        if !sentChildren.isEmpty
        {
            childLabel.isHidden = true
            childTableView.isHidden = false
            self.childTableView.reloadData()
            
        }
        else{
            childTableView.isHidden = true
            childLabel.isHidden = false
            childLabel.text = "This person has no children"
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sentChildren.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCELL", for: indexPath)
        
        // Configure the cell...
        let cellData = sentChildren[indexPath.row]
        
        cell.textLabel?.text = cellData
        
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
