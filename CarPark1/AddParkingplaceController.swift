//
//  AddParkingplaceController.swift
//  
//
//  Created by Nguyen Van Tho on 5/23/17.
//
//

import UIKit

class AddParkingplaceController: UIViewController {

    var parkingLocation : [String:Any]!
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var cappacity: UITextField!
    @IBOutlet weak var price: UITextField!
    var lat : Double!
    var long1: Double!
    /*
     <parkingLocation>
        <capacity>100</capacity>
        <idParkingLocation>1</idParkingLocation>
        <lat>21.027541</lat>
        <long1>105.834676</long1>
        <name>quoc tu giam</name>
        <remain>20</remain>
     </parkingLocation>
    */
 
 
 
    
    
    
    
    @IBAction func addPlaceClick(_ sender: Any) {
        parkingLocation = [:]
        parkingLocation["name"] = address.text
        parkingLocation["capacity"] =  Int (cappacity.text!)
        parkingLocation["lat"] = lat
        parkingLocation["long1"] = long1
        //parkingLocation[""]
        
        makeHTTPPostRequest(path: "http://42.112.16.180:9898/EnglishDics/webresources/model.parkinglocation", body: parkingLocation)
        
        let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "mapviewcontroller") as! MapViewController
        self.present(mapViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        parkingLocation["capacity"] = 100
//        parkingLocation["name"] = "Nguyen khanh toan"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
   
    
    func makeHTTPPostRequest(path: String, body: [String: Any]) {
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
        try
            
            request.httpBody = JSONSerialization.data(withJSONObject: body, options: [])
            //print(JSONSerialization.data(withJSONObject: body, options: [])
        } catch  {
            print("error create body")
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            if (err != nil){
                print (err)
            }else{
                let printableData = String(bytes: data!, encoding: String.Encoding.utf8)
                print("value ",printableData)
            }
        print("Entered the completionHandler")
        }.resume()
        
    }
}
