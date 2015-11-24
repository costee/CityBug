//
//  HistoryViewController.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 12..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit
import Realm

class HistoryViewController: UITableViewController {
    
    func askDiagnosticsSending() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let shouldSendDiagnostics = defaults.boolForKey("allows_data_sending")
        if RouteStore.sharedInstance.count > 2 && !shouldSendDiagnostics {
            let alert = UIAlertController(title: "Do you want to share anonymous user data with CityBug?", message: "No personal information or location data will be sent", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                
                defaults.setBool(true, forKey: "allows_data_sending")
            }))
            alert.addAction(UIAlertAction(title: "Decide Later", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteAll(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Are you sure you want to delete all \(RouteStore.sharedInstance.count) saved routes?", message: "This action cannot be undone.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Delete All", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) -> Void in
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            
            realm.deleteAllObjects()
            do {
            try realm.commitWriteTransaction()
            }
            catch {
                print("Baj van a törléssel");
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the number of rows in the section.
        return Int(RouteStore.sharedInstance.count)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Route", forIndexPath: indexPath) as! RouteViewCell
        
        cell.route = RouteStore.sharedInstance.get(indexPath.row)

        return cell
    }
    

 
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            RouteStore.sharedInstance.removeAt(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        askDiagnosticsSending()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "DetailsSegue" {
            if let destination = segue.destinationViewController as? DetailsController, routeIndex = tableView.indexPathForSelectedRow?.row {
                    destination.route = RouteStore.sharedInstance.get(routeIndex)
            }
        }
    }


}
