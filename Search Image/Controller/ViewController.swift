//
//  ViewController.swift
//  Search Image
//
//  Created by MacBook Pro on 4/7/20.
//  Copyright © 2020 skarev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Properties
    
    private var model: DataModel = DataModel()
    private var mainView: MainView? {
        return self.view as? MainView
    }
    
    //MARK:- Methods
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView?.delegate = self
        model.delegate = self
        mainView?.setupUI()
    }
    
}

//MARK:- Delegate extension

extension ViewController: SearchDelegate {
    func startToSearch(_ text: String) {
        self.showSpinner()
        self.model.getData(text)
    }
}

extension ViewController: RefreshDataDelegate {
    func refreshViewWithNewData(item: SearchItem?) {
        mainView?.refreshWithNewData(item)
        self.removeSpinner()
    }
    
    func showAlert(_ text: String?) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] action in
            self?.removeSpinner()
        }))
        self.present(alert, animated: true)
    }
}
