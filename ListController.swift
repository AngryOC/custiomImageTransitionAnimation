//
//  ListController.swift
//  animationtest
//
//  Created by wang chao on 2019/4/11.
//  Copyright © 2019 bigfish. All rights reserved.
//

import UIKit

class ListController: UITableViewController, UINavigationControllerDelegate, ImageTransitionCDelegate {
    private let kCellHeight: CGFloat = UIScreen.main.bounds.size.width*0.7
    var dataSouce: [String] = ["ic_0","ic_1","ic_2","ic_3","ic_4","ic_5","ic_6"]

    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    
    var imageMode: UIView.ContentMode = .scaleAspectFill
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       tableView.frame = CGRect(origin: .zero, size: view.bounds.size)
    }
    
    func willTransitionPrepareInfo()->(UIImageView?, String?){
        if let selectRow = tableView.indexPathForSelectedRow  {
            if let cell = tableView.cellForRow(at: selectRow) as? ListCell{
                return (cell.imageV, cell.model)
            }
        }
        return (nil, nil)
    }
    
    
    @IBAction func ChangeImageViewContentMode(_ sender: UIBarButtonItem) {
        if imageMode == .scaleAspectFit{
            imageMode = .scaleAspectFill
            sender.title = "AspectFill"
            tableView.reloadData()
            return
        }
        if imageMode == .scaleAspectFill{
            imageMode = .scaleAspectFit
            sender.title = "AspectFit"
            tableView.reloadData()
            return
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSouce.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
        cell.imageV.contentMode = imageMode
        cell.model = dataSouce[indexPath.row]
        return  cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true )
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        vc.image = UIImage(named: dataSouce[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController?.delegate === self {
            navigationController?.delegate = nil
        }
    }
    
     func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (fromVC == self) && (toVC is DetailController) {
            return ImageTransition()
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
