//
//  ViewController.swift
//  CDTests
//
//  Created by David Baker on 12/21/15.
//  Copyright © 2015 Worth Baker. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  var people = [Person]()
  private let moc = DataController().managedObjectContext
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let fetchRequest = NSFetchRequest(entityName: "Person")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
    
    //3
    do {
      let results =
      try self.moc.executeFetchRequest(fetchRequest)
      people = results as! [Person]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
  }
  
  @IBAction func addButtonTapped(sender: AnyObject) {
    let alert = UIAlertController(title: "New Name",
      message: "Add a new name",
      preferredStyle: .Alert)
    
    let saveAction = UIAlertAction(title: "Save",
      style: .Default,
      handler: { (action:UIAlertAction) -> Void in
        
        let entity =  NSEntityDescription.entityForName("Person",
          inManagedObjectContext:self.moc)
        
        let person = NSManagedObject(entity: entity!,
          insertIntoManagedObjectContext: self.moc) as! Person
        person.dateCreated = NSDate()
        
        guard let textFields = alert.textFields else { return }
        for field in textFields {
          switch field.tag {
          case 1:
            person.firstName = field.text!
          case 2:
            person.lastName = field.text!
          default:
            return
          }
        }
        
        let indexPath = self.savePersonAndReturnIndexPath(person)
        
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
    })
    
    let cancelAction = UIAlertAction(title: "Cancel",
      style: .Default) { (action: UIAlertAction) -> Void in
    }
    
    alert.addTextFieldWithConfigurationHandler {
      (textField) -> Void in
      textField.tag = 1
    }
    
    alert.addTextFieldWithConfigurationHandler {
      (textField) -> Void in
      textField.tag = 2
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    presentViewController(alert,
      animated: true,
      completion: nil)
  }
  
  private func savePersonAndReturnIndexPath(person: Person) -> NSIndexPath {
    self.people.append(person)
    let indexPath = NSIndexPath(forRow: self.people.count - 1, inSection: 0)
    
    do {
      try self.moc.save()
    } catch {
      print("error occured: \(error)")
    }
    
    return indexPath
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
    
    let person = people[indexPath.row]
    let firstName = person.firstName!
    let lastName = person.lastName!
    let dateCreated = person.dateCreated!
    
    let formatter = NSDateFormatter()
    formatter.dateStyle = .NoStyle
    formatter.timeStyle = .ShortStyle
    
    let dateString = formatter.stringFromDate(dateCreated)
    
    cell.textLabel?.text = "\(firstName) \(lastName), created at \(dateString)"
    
    return cell
  }
  
}