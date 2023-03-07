//
//  MovieDetailsViewController.swift
//  The Movies
//
//  Created by Bruno Costa on 27/01/23.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {

    var movie: Movie? = nil
    
    var genres: [Genre] = []

    var favoriteButton = UIBarButtonItem()
    
    var moviePosterImageView: UIImageView = {
        let moviePosterImageView = UIImageView()
        moviePosterImageView.backgroundColor = .clear
        moviePosterImageView.contentMode = .scaleToFill
        moviePosterImageView.clipsToBounds = true
        moviePosterImageView.layer.borderColor = UIColor.systemYellow.cgColor
        moviePosterImageView.layer.borderWidth = 1
        moviePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        return moviePosterImageView
    }()
    
    var movieGenreLabel: UILabel = {
        let movieGenreLabel = UILabel()
        movieGenreLabel.font = UIFont.systemFont(ofSize: 18)
        movieGenreLabel.textColor = .gray
        movieGenreLabel.textAlignment = .left
        movieGenreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return movieGenreLabel
    }()
    
    var movieYearLabel: UILabel = {
        let movieYearLabel = UILabel()
        movieYearLabel.font = UIFont.systemFont(ofSize: 18)
        movieYearLabel.textColor = .gray
        movieYearLabel.textAlignment = .left
        movieYearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return movieYearLabel
    }()
    
    var movieDescriptionTextView: UITextView = {
        let movieDescriptionTextView = UITextView()
        movieDescriptionTextView.font = UIFont.systemFont(ofSize: 16)
        movieDescriptionTextView.textAlignment = .left
        movieDescriptionTextView.isEditable = false
        movieDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        return movieDescriptionTextView
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        self.setupViews()
        self.setupData()
        self.setupFavoriteButton()
        self.fetchGenres()
        self.setupConstraints()
    }
    
    func setupFavoriteButton() {
        self.favoriteButton = UIBarButtonItem(image: UIImage(systemName: checkIsFavorite(movie: self.movie!) ? "star.fill" : "star"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        self.favoriteButton.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc func favoriteButtonTapped() {
        self.toggleFavorite(movie: self.movie!)
    }
    
    
    func fetchGenres() {
        Webservice().fetchGenres(url: Constants.Urls.urlForGenres()) { result, error in
            if error != nil {
                return 
            }
            if let result = result {
                self.genres = result
                self.setupGenres()
            }
        }
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
    
    func toggleFavorite(movie: Movie) {
        let movie = self.movie
        let isFavorite = self.checkIsFavorite(movie: movie!)
        
        if isFavorite {
            FavoriteManager().remove(movie: movie!) { movie, error in
                if error != nil {
                    // TODO: tratar erroz
                }
                if movie != nil {
                    DispatchQueue.main.async {
                        self.favoriteButton.image = UIImage(systemName: "star")
                    }
                }
            }
        } else {
            FavoriteManager().save(movie: movie!) { movie, error in
                if error != nil {
                    // TODO: tratar erro
                }
                if movie != nil {
                    DispatchQueue.main.async {
                        self.favoriteButton.image = UIImage(systemName: "star.fill")
                    }
                }
            }
        }
    }
    
    
    func setupGenres() {
        let filteredIds = self.movie?.genre_ids ?? []
        let filteredGenres = self.genres.filter { filteredIds.contains($0.id) }
        var genresText = ""
        for genre in filteredGenres {
            genresText += genre.name + ", "
        }
        self.movieGenreLabel.text = String(genresText.dropLast(2))
    }
    
    func setupData() {
        self.title = movie?.title
        self.movieYearLabel.text = "Release date: \(movie?.release_date ?? "")"
        self.movieDescriptionTextView.text = movie?.overview
        self.setupPoster()
    }
    
    func setupPoster() {
        let imageURL = Constants.Urls.urlForPosterMovies(poster_path: self.movie!.poster_path)
        self.moviePosterImageView.sd_setImage(with: imageURL)
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 450),
            moviePosterImageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
                                    
        NSLayoutConstraint.activate([
            movieYearLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 16),
            movieYearLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            movieYearLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            movieGenreLabel.topAnchor.constraint(equalTo: movieYearLabel.bottomAnchor, constant: 16),
            movieGenreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            movieGenreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        
        NSLayoutConstraint.activate([
            movieDescriptionTextView.topAnchor.constraint(equalTo: movieGenreLabel.bottomAnchor, constant: 16),
            movieDescriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            movieDescriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            movieDescriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func setupViews() {
        view.addSubview(moviePosterImageView)
        view.addSubview(movieYearLabel)
        view.addSubview(movieGenreLabel)
        view.addSubview(movieDescriptionTextView)
    }
}
