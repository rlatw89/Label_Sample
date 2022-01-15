//
//  MainViewController.swift
//  LabelSample
//
//  Created by Taewan_MacBook on 2022/01/15.
//

import Foundation
import UIKit

class MainViewController : UIViewController {
    
    var tableViewBottomConstraints: NSLayoutConstraint
    let viewModel = MainViewModel()
    
    /// Set navigation component
    private func navigationBarComponent() {
        title = "Label Sample"
        view.backgroundColor = .lightGray
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private lazy var textView : TextView = {
        let textView = TextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.placeHolder = "Enter text."
        textView.placeHolderTextColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.layer.cornerRadius = 10
        return textView
    } ()
    
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        return tableView
    } ()
    
    private lazy var submitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("submit", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(submitButtonTouch), for: .touchUpInside)
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc private func submitButtonTouch() {
        
    }
    
    private func configuration() {
        textView.thresholdHeight = view.bounds.height / 4
    }
    
    private func setConstraints() {
        let textWrapper = UIView()
        textWrapper.translatesAutoresizingMaskIntoConstraints = false
        textWrapper.backgroundColor = .darkGray
        view.addSubview(textWrapper)
        
        textWrapper.addSubview(textView)
        textWrapper.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            textWrapper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textWrapper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textWrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: textWrapper.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: textWrapper.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: textWrapper.topAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: textWrapper.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: textWrapper.topAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: textWrapper.trailingAnchor, constant: -20),
            submitButton.widthAnchor.constraint(equalToConstant: submitButton.intrinsicContentSize.width)
        ])
        
        tableViewBottomConstraints = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: textWrapper.bottomAnchor),
            tableViewBottomConstraints
        ])
    }
}
