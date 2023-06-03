//
//  MovieListView.swift
//  MovieShowList
//
//  Created by Macbook Pro on 6/3/23.
//

import UIKit

class MovieListView: UIView {
    
    //MARK: - Properties
    
    let movieCellIdentifier = "movieCell"
    
    lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        if let textfield = sb.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        sb.searchTextField.font = UIFont(name: "kefa", size: 18)
        sb.searchTextField.textColor = .blue
        sb.searchTextField.backgroundColor = .clear
        sb.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        sb.layer.borderColor = UIColor(hexString: "#28283F").cgColor
        sb.layer.borderWidth = 1
        sb.tintColor = .blue
        sb.barStyle = .default
        sb.setImage(UIImage(named: "Search Icon"), for: .search, state: .normal)
        sb.searchTextPositionAdjustment = UIOffset(horizontal: Utility.convertWidthMultiplier(constant: 10), vertical: 0)
        listTableView.tableHeaderView = sb
        sb.showsCancelButton = true
        return sb
        
    }()

    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setUpSubviews(){
        self.backgroundColor = .white
        addSubview(listTableView)
        listTableView.fillSuperView()
        listTableView.register(MovieCell.self, forCellReuseIdentifier: movieCellIdentifier)
    }
}
