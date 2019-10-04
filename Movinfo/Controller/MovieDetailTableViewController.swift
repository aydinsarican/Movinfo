//
//  MovieDetailTableViewController.swift
//  Movinfo
//
//  Created by Aydn on 3.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class MovieDetailTableViewController: UITableViewController {
    
    private var movieDetail: MovieDetailModel?
    var movieId = ""
    var movieName = ""
    var pNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        getSelectedMovieDetail()
    }
    
    func setupUI()
    {
        tableView.register(UINib(nibName: "MovieDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "detailCell")
        tableView.register(UINib(nibName: "MovieDetailHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        tableView.tableFooterView = UIView()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = movieName
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.backBarButtonItem?.title = "Back"
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func getSelectedMovieDetail()
    {
        MovieService.getMovieDetailBy(movieId: movieId) { (response) in
            switch response {
            case .success(let movieDetailModel):
                self.movieDetail = movieDetailModel
                
                let mirrorObj = Mirror(reflecting: movieDetailModel)
                var movieDetailLogDict: [String : String] = [:]
                for (_, attr) in mirrorObj.children.enumerated()
                {
                    if let pName = attr.label
                    {
                        let name = pName.capitalizingFirstLetter()
                        if "\(attr.value)" == "N/A"
                        {
                            self.pNames.append("\(name):\t -")
                        }
                        else
                        {
                            self.pNames.append("\(name):\t \(attr.value)")
                        }
                        
                        //The maximum supported length is 100
                        let trimmedString = "\(attr.value)".prefix(99)
                        movieDetailLogDict[name] = String(trimmedString)
                    }
                }
                self.logMovieDetails(movieLogDict: movieDetailLogDict)
                self.tableView.reloadData()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 // headerView
        {
            return 1
        }
        else  // details
        {
            return pNames.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 // headerView
        {
            return 530
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 // headerView
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as? MovieDetailHeaderTableViewCell {
                cell.posterImageView.sd_setImage(with: URL(string: self.movieDetail?.poster ?? ""), placeholderImage: UIImage(named: "posterPlaceholder.png"))
                return cell
            }
        }
        else
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? MovieDetailTableViewCell {
                
                cell.textLabel?.text = pNames[indexPath.row]
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func logMovieDetails(movieLogDict: [String : String]) {
        print(movieLogDict)
        Analytics.logEvent("selectedMovieDetail", parameters: movieLogDict)
    }
}
