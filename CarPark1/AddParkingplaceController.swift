//
//  AddParkingplaceController.swift
//  
//
//  Created by Nguyen Van Tho on 5/23/17.
//
//

import UIKit

class AddParkingplaceController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var parkingLocation : [String:Any]!
    var addressValue: String!

    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var cappacity: UITextField!
    @IBOutlet weak var remain: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
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
 
 
    @IBOutlet weak var imageView: UIImageView!
 

    @IBAction func chosenImagePresent(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            //imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,
                         completion: nil)
        }
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.dismiss(animated: true, completion: nil)
            imageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPlaceClick(_ sender: Any) {
        parkingLocation = [:]
        parkingLocation["name"] = name.text
        parkingLocation["capacity"] =  Int (cappacity.text!)
        parkingLocation["lat"] = lat
        parkingLocation["long1"] = long1
        parkingLocation["address"] = address.text
        parkingLocation["phoneNumber"] = phoneNumber.text
        parkingLocation["remain"] = Int (remain.text!)
        //parkingLocation[""]
       
        makeHTTPPostRequest(path: "http://192.168.10.7:8080/EnglishDics/webresources/model.parkinglocation/createLocation", body: parkingLocation, chosenImage: imageView.image!)
       
        
        
        
        let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "mapviewcontroller") as! MapViewController
        self.present(mapViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        address.text = addressValue
        
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
    
    func makeHTTPPostRequest(path: String, body: [String: Any], chosenImage: UIImage) {
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "POST"
        // Post with multile value
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
       // let params = ["parkingInfo":JSONSerialization.data(withJSONObject: body, options: [])]
        
        
        
       // let chosenImage = UIImage()
       // UIImageJPEGRepresentation(image: UIImage, <#T##compressionQuality: CGFloat##CGFloat#>)
        var params = [String:Data]()
        do {
            let bodydata = try JSONSerialization.data(withJSONObject: body, options: [])
            params = ["parkingInfo":bodydata]
        } catch  {
            print("error")
        }
        
        request.httpBody =  createBody(parameters: params,
                   boundary: boundary,
                   data: UIImageJPEGRepresentation(chosenImage, 0.7)!,
                   mimeType: "image/jpg",
                   filename: "sample.jpg")
    
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
    
    func createBody(parameters: [String: Data],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appenString(boundaryPrefix)
            body.appenString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append(value)
            body.appenString("\r\n")
        }
        
        body.appenString(boundaryPrefix)
        body.appenString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appenString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appenString("\r\n")
        body.appenString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}

extension NSMutableData {
    func appenString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
