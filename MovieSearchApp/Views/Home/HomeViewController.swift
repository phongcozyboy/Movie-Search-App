//
//  HomeViewController.swift
//  MovieSearchApp
//
//  Created by Phong Le on 15/06/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var movies = [Movie]()
    private var checkLoad = false
    private var searchActive = false
    private var searched = true
    private var page = 1
    private var query = ""
    private let database = CoreDataManager.shared
    
    struct Constants {
        static func moviePopular(page: Int) -> String {
            return "https://api.themoviedb.org/3/movie/popular?api_key=d02a177cf676deb53aace9fd45bd91e6&language=en-US&page=\(page)"
        }
        
        static func movieSearch(query: String, page: Int) -> String {
            return "https://api.themoviedb.org/3/search/movie?api_key=d02a177cf676deb53aace9fd45bd91e6&query=\(query)&page=\(page)"
        }
    }
    
    enum URLMovie {
        case search(String, Int)
        case popular(Int)
        
        var url: String {
            switch self {
            case .popular(let page):
                return Constants.moviePopular(page: page)
            case .search(let query, let page):
                return Constants.movieSearch(query: query, page: page)
            }
        }
    }
    
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
        
        self.fetchMoviesFromAPI(type: .popular(self.page))
        self.configureView()
        self.configureTableView()
        self.configureSearchBar()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapDismissKeyboard))
//
//        self.view.addGestureRecognizer(tap)
        
    }
    
//    @objc private func didTapDismissKeyboard() {
//        self.view.endEditing(true)
//    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "The Movies"
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
    }
    
    func configureSearchBar() {
        self.searchBar.delegate = self
    }
    
    func fetchMoviesFromAPI(type: URLMovie) {
        let session = URLSession.shared
        guard let url = URL(string: type.url) else { return }
        
        DispatchQueue.global().async {
            let fetchAPITask = session.dataTask(with: url) { (data, _, err) in
                if err != nil {
                    print(err!.localizedDescription)
                }
                
                guard let data = data else { return }
                let movies = try? JSONDecoder().decode(Movies.self, from: data)
                
                self.movies.append(contentsOf: movies!.results)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.tableFooterView = nil
                    self.tableView.tableHeaderView = nil
                    self.checkLoad.toggle()
                }
            }
            
            fetchAPITask.resume()
        }
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
        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = uiView.center
        spinner.startAnimating()
        uiView.addSubview(spinner)
        
        return uiView
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.database.createMovie(movie: self.movies[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.checkLoad &&
            scrollView.contentOffset.y > (self.tableView.contentSize.height - scrollView.frame.size.height + 300) {
            self.tableView.tableFooterView = self.createSpinnerFooter()
            self.page += 1
            self.fetchMoviesFromAPI(type: self.query == "" ? .popular(self.page) : .search(self.query, page))
            self.checkLoad.toggle()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        cell.configure(movie: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension HomeViewController: UISearchBarDelegate {
    func configureWhenCallSearch() {
        self.page = 1
        self.movies = []
        self.tableView.reloadData()
        self.fetchMoviesFromAPI(type: self.query == "" ? .popular(self.page) : .search(self.query, self.page))
        self.tableView.tableHeaderView = self.createSpinnerFooter()
        self.checkLoad.toggle()
        self.searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !self.searched && searchText == "" {
            self.searched = true
            self.query = ""
            self.configureWhenCallSearch()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.replacingOccurrences(of: " ", with: "+") else { return }
        self.query = query
        self.searched = false

        self.configureWhenCallSearch()
    }
}
