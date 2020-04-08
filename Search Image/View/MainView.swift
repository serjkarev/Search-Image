//
//  MainView.swift
//  Search Image
//
//  Created by MacBook Pro on 4/7/20.
//  Copyright © 2020 skarev. All rights reserved.
//

import UIKit

class MainView: UIView {

    //MARK:- Properties
    
//    public var data: [SearchItem] = [SearchItem(image: UIImage(named: "medium_skarev")!, name: "first0"),
//                                     SearchItem(image: UIImage(named: "medium_skarev")!, name: "second0"),
//                                     SearchItem(image: UIImage(named: "medium_skarev")!, name: "third0"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "first1"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "second1"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "third1"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "first2"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "second2"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "third2"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "first3"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "second3"),
//                                        SearchItem(image: UIImage(named: "medium_skarev")!, name: "third3")]
    private var searchBar: UISearchBar?
    private var tableView: UITableView?
    
    // MARK: Init and Deinit

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    private func commonInit() {
        self.searchBar = UISearchBar(frame: .init(x: 0, y: 0, width: 1, height: 1))
        self.tableView = UITableView(frame: .init(x: 0, y: 0, width: 1, height: 1))
        if let search = self.searchBar {
            self.addSubview(search)
        }
        if let table = self.tableView {
            self.addSubview(table)
        }
        self.searchBar?.delegate = self
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(MyTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView?.allowsSelection = false
    }
    
    //MARK:- Methods
    
    public func setupUI() {
        self.backgroundColor = .white
        makeConstraints()
    }
    
    public func makeConstraints() {
        self.searchBar?.translatesAutoresizingMaskIntoConstraints = false
        self.tableView?.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        guard let search = self.searchBar else {return}
        constraints.append(contentsOf: [
            NSLayoutConstraint(item: search, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: search, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: search, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        ])
        guard let table = self.tableView else {return}
        constraints.append(contentsOf: [
            NSLayoutConstraint(item: table, attribute: .top, relatedBy: .equal, toItem: search, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: table, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: table, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: table, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
        self.removeConstraints(self.constraints)
        self.addConstraints(constraints)
    }
    
}

//MARK:- Extensions

    //MARK:- UISearchBar delegate methods

extension MainView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

    //MARK:- UITableViewDelegate & UITableViewDataSource methods

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyTableViewCell {
            cell.setData(data: data.dropFirst(indexPath.row).first)
            return cell
        }
        return UITableViewCell()
    }
    
    
}
