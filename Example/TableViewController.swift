//
//  TableViewController.swift
//  JTLoadMoreControl
//
//  Created by ZhouJiatao on 10/02/2017.
//  Copyright © 2017 ZhouJiatao. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, FakeCommunicatorDelegate {
    var loadMoreControl = JTLoadMoreControl()
    var communicator = FakeCommunicator()
    var model = FakeTableModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "网络正常"

        communicator.delegate = self
        tableView.tableFooterView = loadMoreControl
        loadMoreControl.addTarget(self, action: #selector(loadingMore), for: .valueChanged)
        communicator.fetchPage(page: 0)
    }

    @IBAction func refreshing(_ sender: UIRefreshControl) {
        communicator.fetchPage(page: 0)
    }
    
    func loadingMore() {
        communicator.fetchPage(page: model.currentPage + 1)
    }
    
    @IBAction func switchNetwork(_ sender: UISwitch) {
        communicator.awaylFetchFaild = sender.isOn
        title = sender.isOn ? "模拟网络异常" : "模拟网络正常"
    
    }
    
    func onFetchSuccess(newTitles: [String],page: Int) {
        if page == 0 {
            model.reset()
        } else {
            model.currentPage = model.currentPage + 1
        }
        
        model.append(newTitles: newTitles)
        refreshControl?.endRefreshing()
        newTitles.isEmpty ? loadMoreControl.endLoadingDueToNoMoreData() : loadMoreControl.endLoading()
        tableView.reloadData()
    }
    
    func onFetchFailed() {
        refreshControl?.endRefreshing()
        loadMoreControl.endLoadingDueToFailed()
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)

        cell.textLabel?.text = model.titles[indexPath.row]

        return cell
    }
    
    

}
