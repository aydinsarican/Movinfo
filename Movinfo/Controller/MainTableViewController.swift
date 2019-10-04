//
//  MainTableViewController.swift
//  Movinfo
//
//  Created by Aydn on 3.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import UIKit
import Lottie

class MainTableViewController: UITableViewController, UISearchBarDelegate {
    
    private var movies = [Movie]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var loadMoreIsCalled = false
    fileprivate var isLoading = false
    fileprivate var searchText: String = ""
    fileprivate var selectedMovieId: String = ""
    fileprivate var selectedMovieName: String = ""
    let loadingView = AnimationView()
    
    var infoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.clearsSelectionOnViewWillAppear = true
    }
    
    func setupUI()
    {
        tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Movinfo"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        showInfoLabel(withText: "Enter a movie name")
        
        let movieAnimation = Animation.named("1961-movie-loading")//("video-cam")//
        loadingView.animation = movieAnimation
        loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)//self.view.center
        loadingView.contentMode = .scaleAspectFit
        loadingView.loopMode = .loop
        loadingView.animationSpeed = 1.5
        loadingView.isHidden = true
        self.view.addSubview(loadingView)
    }
    
    func loader(show: Bool)
    {
        if show {
            loadingView.play()
            loadingView.isHidden = false
        }
        else
        {
            loadingView.stop()
            loadingView.isHidden = true
        }
    }
    
    func showInfoLabel(withText text: String) {
        infoLabel.frame.size = CGSize.zero
        infoLabel.font = UIFont(name: "Montserrat", size: 17)
        infoLabel.textColor = UIColor.lightGray
        infoLabel.textAlignment = .center
        infoLabel.text = text
        infoLabel.sizeToFit()
        tableView.backgroundView = infoLabel
    }
    
    func searchMovies(searchText: String)
    {
        self.loader(show: true)
        let encodedString = searchText.replacingOccurrences(of: " ", with: "+")
        
        MovieService.getMoviesBy(searchKey: encodedString) { (response) in
            print(response)
            self.loader(show: false)
            self.movies.removeAll()
            switch response {
            case .success(let movieModel):
                print(movieModel)
                self.movies.append(contentsOf: movieModel.movies ?? [Movie]())
                if self.movies.count == 0
                {
                    self.infoLabel.text = "No movies found"
                }
                else
                {
                    self.infoLabel.text = ""
                }
                self.tableView.reloadData()
            case .failure(let error):
                //self.showAlert(title: "Warning", message: "Error - \(error)")
                self.infoLabel.text = "Something went wrong"
                print(error.localizedDescription)
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.count != 0 {
            searchMovies(searchText: searchText)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MoviesTableViewCell{
            cell.setupCell(with: movies[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = movies[indexPath.row].imdbID else { return }
        selectedMovieId = id
        selectedMovieName = movies[indexPath.row].title ?? ""
        performSegue(withIdentifier: "movieDetailSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegue" {
            if let vc = segue.destination as? MovieDetailTableViewController {
                vc.movieId = self.selectedMovieId
                vc.movieName = self.selectedMovieName
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerm = searchController.searchBar.text {
            guard searchTerm.count > 2 else { return}
            self.searchText = searchTerm
            searchMovies(searchText: self.searchText)
        }
    }
}

