//
//  ViewController.swift
//  SampleSwift
//
//  Created by qbuser on 30/01/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import UIKit
import Foundation
import SwiftLoggly
import SwiftCSVExport

class User {
    var userid:Int = 0
    var name:String = ""
    var email:String = ""
    var isValidUser:Bool = false
    var message:String = ""
    var balance:Double = 0.0
}


class ViewController: UIViewController {
    
    @IBOutlet var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate CSV file
        let user1:NSMutableDictionary = NSMutableDictionary()
        user1.setObject(107, forKey: "userid" as NSCopying);
        user1.setObject("vignesh", forKey: "name" as NSCopying);
        user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);
        user1.setObject(true, forKey:"isValidUser" as NSCopying)
        user1.setObject("Hi 'Vignesh!' \nhow are you? \t Shall we meet tomorrow? \r Thanks, Vignesh ", forKey: "message" as NSCopying);
        user1.setObject(571.05, forKey: "balance" as NSCopying);
        
        let user2:NSMutableDictionary = NSMutableDictionary()
        user2.setObject(108, forKey: "userid" as NSCopying);
        user2.setObject("vinoth", forKey: "name" as NSCopying);
        user2.setObject(false, forKey:"isValidUser" as NSCopying)
        user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);
        user2.setObject("Hi \"'Vinoth!',; \nHow are you? \t Shall we meet tomorrow? \r Thanks, Vinoth ", forKey: "message" as NSCopying);
        user2.setObject(567.50, forKey: "balance" as NSCopying);
    
        let data:NSMutableArray  = NSMutableArray()
        data.add(user1);
        data.add(user2);
        
        let user3 = User()
        user3.userid = 109
        user3.name = "John"
        user3.email = "John@gmail.com"
        user3.isValidUser = true
        user3.message = "Hi 'John!'; \nHow are you? \t Shall we meet tomorrow? \r Thanks "
        user3.balance = 105.41;
        data.add(listPropertiesWithValues(user3)) // Able to convert Class object into NSMutableDictionary
        
        let header = ["userid", "name", "email", "message", "isValidUser","balance"]
        // Create a object for write CSV
        let writeCSVObj = CSV()
        writeCSVObj.rows = data
        writeCSVObj.delimiter = DividerType.comma.rawValue
        writeCSVObj.fields = header as NSArray
        writeCSVObj.name = "userlist"
        
        // Write File using CSV class object
        let output = CSVExport.export(writeCSVObj);
        if output.result.isSuccess {
            guard let filePath =  output.filePath else {
                print("Export Error: \(String(describing: output.message))")
                return
            }
            
            print("File Path: \(filePath)")
            self.readCSVPath(filePath)
        } else {
            print("Export Error: \(String(describing: output.message))")
        }
        
        let fileManager = FileManager.default
        if let fileURL = Bundle.main.url(forResource: "test", withExtension: "json") {
            print(fileURL)
            
            let filePath = fileURL.path
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                print("File exists")
                self.readCSVPath(filePath)
            } else {
                print("File does not exist")
            }
        }

    }
    
    func readCSVPath(_ filePath: String) {

        let request = NSURLRequest(url:  URL(fileURLWithPath: filePath) )
        webview.loadRequest(request as URLRequest)
        
        // Read File and convert as CSV class object
        let readCSVObj = CSVExport.readCSVObject(filePath);
        
        // Use 'SwiftLoggly' pod framework to print the Dictionary
        loggly(LogType.Info, text: readCSVObj.name)
        loggly(LogType.Info, text: readCSVObj.delimiter)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
