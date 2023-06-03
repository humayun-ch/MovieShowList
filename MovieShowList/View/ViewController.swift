//
//  ViewController.swift
//  MovieShowList
//
//  Created by Macbook Pro on 6/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    var movieList: MovieList?{
        didSet{
            guard let _ = movieList else {return}
            DispatchQueue.main.async {[self] in
                listView.listTableView.reloadData()
            }
        }
    }
    
    lazy var listView: MovieListView = {
        let view = MovieListView()
        view.listTableView.delegate = self
        view.listTableView.dataSource = self
        view.searchBar.delegate = self
        return view
    }()
    
    var movieDetailsVM = MovieDetailsVM()
    var currentPage = 1
    var searchKeyWord = "Marvel"
    
    //MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getMovieList()
    }
    
    //MARK: - Functions
    
    private func setupViews(){
        view.addSubview(listView)
        listView.fillSuperView()
    }
    
    private func getMovieList(){
        showActivityIndicator()
        movieDetailsVM.getMovieList(page: currentPage, query: searchKeyWord) {[weak self] list, error in
            guard let self = self, let list = list else {
                return
            }
            self.hideActivityIndicator()
            self.movieList = list
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.endEditing(true)
        currentPage = 1
        searchKeyWord = searchBar.text ?? ""
        getMovieList()
    }
    

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("canceled searbar")
        
        currentPage = 1
        searchKeyWord = "Marvel"
        getMovieList()

        searchBar.searchTextField.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listView.movieCellIdentifier, for: indexPath) as! MovieCell
        if let movieList = movieList?.results?[indexPath.row]{
            if let posterPath = movieList.posterPath{
                cell.posterImageView.loadImageUsingCache(withUrl: MovieWebServices.endpoints.posterBaseURL + posterPath, showPlaceHolder: true)
            }else{
                cell.posterImageView.image = #imageLiteral(resourceName: "placeholder")
            }
            cell.titleLabel.text = movieList.title
            cell.descLabel.text = movieList.overview
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Movie List"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let overView = movieList?.results?[indexPath.row].overview{
            let descLabelHeight = Utility.calculateHeight(inString: overView)
            // Compare Cell Height with cell poster imageView [Height: 140] so that imageView Doesn't come out of the cell/crops
            if (descLabelHeight < 140){
                return 140
            }else{
                return descLabelHeight
            }
        }
        return CGFloat()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (movieList?.results?.count ?? 0) - 1{
            if (movieList?.page) ?? 0 >= (movieList?.totalPages) ?? 0{
                print("⚠️ No more data")
                return
            }
            currentPage += 1
            showActivityIndicator()
            movieDetailsVM.getMovieList(page: currentPage, query: "marvel") { [weak self] movieList, error in
                guard let self = self, let movieList = movieList else {
                    return
                }
                self.movieList?.page = movieList.page
                self.movieList?.results?.append(contentsOf: movieList.results!)
                self.hideActivityIndicator()
            }
        }
    }
}

