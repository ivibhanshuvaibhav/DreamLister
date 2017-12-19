//
//  DreamsVC.swift
//  DreamLister
//
//  Created by Vibhanshu Vaibhav on 01/12/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class DreamsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    var items = [Item]()
    var item: Item!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCoreDataObject(segmentController.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchCoreDataObject(_ index: Int) {
        fetch(index: index) { (complete) in
            if complete {
                if items.count >= 1 {
                    tableView.isHidden = false
                    tableView.reloadData()
                    tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func segmentControllerValueChanged(_ sender: Any) {
        fetchCoreDataObject(segmentController.selectedSegmentIndex)
    }
    
}

extension DreamsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell else { return UITableViewCell() }
        let item = items[indexPath.row]
        cell.configureCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item = items[indexPath.row]
        performSegue(withIdentifier: "EditDreamSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDreamSegue" {
            let destinationVC = segue.destination as! CreateDreamVC
            destinationVC.initData(item: item)
        }
    }
    
}

extension DreamsVC {
    
    func fetch(index: Int, completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if index == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if index == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if index == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        do {
            items = try managedContext.fetch(fetchRequest) as! [Item]
            debugPrint("Successfully fetched")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
