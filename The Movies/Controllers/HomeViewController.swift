//
//  ViewController.swift
//  The Movies
//
//  Created by Bruno Costa on 27/01/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FavoriteDelegate, UIGestureRecognizerDelegate {
    
    private var isLoading = false
    private var isError = false
    private var page = 1
    var popularMovies = [Movie]()
   
    
    var emptyView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "The Movies"
        view.backgroundColor = .white
        self.showSpinner()
        self.setupCollectionView()
        self.popularMovies = []
        self.page = 1
        self.fetchMovies(page: page)
        self.setupTapGesture()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reloadData))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      if let view = touch.view, view.isDescendant(of: collectionView) {
        return false
      }
      return true
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        if(self.collectionView.contentOffset.y >= (collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
            if !collectionView.isHidden && isError == false {
                self.fechNextPage()
            }
        }
    }
    
    func fechNextPage() {
        if !self.isLoading {
            self.isLoading = true
            self.page = self.page + 1
            self.fetchMovies(page: self.page)
        }
        self.isLoading = false
    }
    
    
    func fetchMovies(page: Int) {
        Webservice().fetchMovies(url: Constants.Urls.urlForPopularMovies(page: page)) { result, error in
            switch error {
            case .CannotFetch(let message):
                
                DispatchQueue.global(qos: .background).async {
                    self.popularMovies = []
                    self.isError = true
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.setupEmptyView(title: message, message: "", messageImage: UIImage(systemName: "xmark.circle")!)
                        self.collectionView.isHidden = true
                        self.collectionView.reloadData()
                    }
                }
            case .none:
                print("")
            }
    
            if let result = result {
                DispatchQueue.global(qos: .background).async {
                    self.popularMovies.append(contentsOf: result)
                    
                    self.isError = false
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.emptyView.removeFromSuperview()
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
        
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    func setupEmptyView(title: String, message: String, messageImage: UIImage) {
        self.emptyView.removeFromSuperview()
        emptyView = self.view.getEmptyView(title: title, message: message, messageImage: messageImage)
        view.addSubview(emptyView)
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emptyView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
      }
    
    
    @objc func reloadData(sender: UITapGestureRecognizer) {
        if isError {
            self.page = 1
            self.fetchMovies(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviePosterCell
        let imageURL = Constants.Urls.urlForPosterMovies(poster_path: self.popularMovies[indexPath.row].poster_path)
        
        let isFavorite = checkIsFavorite(movie: self.popularMovies[indexPath.row])
        
        cell.delegate = self
        
        cell.configure(indexPath: indexPath, title: self.popularMovies[indexPath.row].title, imageURL: imageURL, isFavorite: isFavorite)
        
        return cell
    }
    
    func checkIsFavorite(movie: Movie) -> Bool{
        var isFavorite = false
        
        FavoriteManager().fetch(movie: movie) { movie, error in
            if error != nil {
                isFavorite = false
            }
            if movie != nil {
                isFavorite = true
            }
        }
        return isFavorite
    }
    
    
    func toggleFavorite(indexPath: IndexPath) {
        let movie = self.popularMovies[indexPath.row]
        let isFavorite = self.checkIsFavorite(movie: movie)
        
        if isFavorite {
            FavoriteManager().remove(movie: movie) { movie, error in
                if error != nil {
                    // TODO: tratar erroz
                }
                if movie != nil {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        } else {
            FavoriteManager().save(movie: movie) { movie, error in
                if error != nil {
                    // TODO: tratar erro
                }
                if movie != nil {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieSelected = self.popularMovies[indexPath.row]
        let movieDetailsVC = MovieDetailsViewController()
        movieDetailsVC.movie = movieSelected
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 300)
    }
}
