//
//  FavoritesViewController.swift
//  MovieSearchApp
//
//  Created by Phong Le on 15/06/2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private var movies = [MovieDatabase]()
    private let database = CoreDataManager.shared
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Enter your film..."
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.configureTableView()
        self.configureSearchBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let movies = self.database.getMovies() else { return }
        self.movies = movies
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Favorites"
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        
        guard let movies = self.database.getMovies() else { return }
        self.movies = movies
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func configureSearchBar() {
        self.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topContainer = UIView()
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(topContainer)
        
        topContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        topContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true

        topContainer.addSubview(self.searchBar)
        
        self.searchBar.topAnchor.constraint(equalTo: topContainer.topAnchor).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor).isActive = true
        
        
        let bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(bottomContainer)
        
        bottomContainer.topAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: (1 - 0.07)).isActive = true
        
        bottomContainer.addSubview(self.tableView)
        
        self.tableView.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 1).isActive = true
    }
    
    func createSpinnerFooter() -> UIView {
        let uiView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: self.view.frame.size.width,
                                          height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = uiView.center
        spinner.startAnimating()
        
        uiView.addSubview(spinner)
        
        return uiView
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
}

extension FavoritesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        let model = self.movies[indexPath.row]
        let movie = Movie(title: model.title, posterPath: model.posterPath, releaseDate: model.releaseDate)
        cell.configure(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.database.deleteMovie(movie: self.movies[indexPath.row])
            self.movies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension FavoritesViewController: UISearchBarDelegate {
    
}
