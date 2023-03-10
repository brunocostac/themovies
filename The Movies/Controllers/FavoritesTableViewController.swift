//
//  FavoritesViewController.swift
//  The Movies
//
//  Created by Bruno Costa on 27/01/23.
//

import UIKit

class FavoritesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var favoriteMovies = [Movie]()
    var filteredMovies = [Movie]()
    let searchBar = UISearchBar()
    
    var errorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "xmark.circle")
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private var isFiltering: Bool {
        return searchBar.text?.isEmpty == false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = "The Movies"
        self.setupTableView()
        self.setupSearchBar()
        self.setupKeyboard()
    }
    
    func setupKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getMovies()
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = searchBar
        self.tableView.rowHeight = 180.0
        self.tableView.backgroundColor = .white
        self.tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Nome do filme"
        searchBar.sizeToFit()
    }
    
    func getMovies() {
        FavoriteManager().fetchAll(completion: { movie, error in
            
            if let movie = movie {
                self.favoriteMovies = movie
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            if let error = error {
                print(error)
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoritesTableViewCell
        
        let movie = isFiltering ? filteredMovies[indexPath.row] : favoriteMovies[indexPath.row]
        
        let imageURL = Constants.Urls.urlForPosterMovies(poster_path: movie.poster_path)
        cell.configure(title: movie.title, overview: movie.overview, release: movie.release_date, imageURL: imageURL)
       
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if self.filteredMovies.count == 0 {
                self.tableView.setEmptyView(title: "No movies with this name were found.", message: "", messageImage: UIImage(systemName: "magnifyingglass.circle")!)
            }
            return filteredMovies.count
        } else if self.favoriteMovies.count == 0 {
            self.tableView.setEmptyView(title: "You do not have any favorites yet.", message: "", messageImage: UIImage(systemName: "star.circle")!)
        } else {
            self.tableView.backgroundView = nil
        }
        return self.favoriteMovies.count
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FavoriteManager().remove(movie: self.favoriteMovies[indexPath.row]) { movie, error in
                if let movie = movie {
                    self.favoriteMovies.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = favoriteMovies.filter({ (movie: Movie) -> Bool in
            return movie.title.lowercased().contains(searchText.lowercased()) ?? false
        })

        tableView.reloadData()
    }
}
