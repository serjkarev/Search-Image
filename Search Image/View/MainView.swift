//
//  MainView.swift
//  Search Image
//
//  Created by MacBook Pro on 4/7/20.
//  Copyright © 2020 skarev. All rights reserved.
//

import UIKit
import RealmSwift

protocol SearchDelegate {
    func startToSearch(_ text: String)
}

class MainView: UIView {

    //MARK:- Properties
    
    var delegate: SearchDelegate?
    public var data: Results<SearchItem>!
    private var searchBar: UISearchBar?
    private var tableView: UITableView?
    private var tableBottomConstraint: NSLayoutConstraint?
    
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
        self.searchBar?.placeholder = "Tap to search"
        self.searchBar?.delegate = self
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(MyTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView?.allowsSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        getDataFromRealmDB()
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
        ])
        self.tableBottomConstraint = NSLayoutConstraint(item: table, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        constraints.append(self.tableBottomConstraint!)
        self.removeConstraints(self.constraints)
        self.addConstraints(constraints)
    }
    
    public func refreshWithNewData(_ data: SearchItem?) {
        guard let dat = data else {return}
//        if dat.imgPath == nil {
//            let filename = getDocumentsDirectory().appendingPathComponent(String(Int(Date().timeIntervalSince1970)) + ".png")
//            print(filename)
////            dat.imgPath = filename
//        }
        saveToRealmDB(dat)
        tableView?.reloadData()
    }
    
    //MARK:- Manage images
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //MARK:- Realm
    
    private func getDataFromRealmDB() {
        do {
            let realm = try Realm()
            self.data = realm.objects(SearchItem.self)
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func saveToRealmDB(_ dat: SearchItem) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dat)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK:- Nitifications
    
    @objc func keyboardWillShow(_ notification:Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {

        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}

//MARK:- Extensions

    //MARK:- UISearchBar delegate methods

extension MainView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
        delegate?.startToSearch(searchBar.text ?? "")
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                let deleteItem = self.data[indexPath.row]
                try realm.write {
                    realm.delete(deleteItem)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
