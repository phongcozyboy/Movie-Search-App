//
//  HomeTableViewCell.swift
//  MovieSearchApp
//
//  Created by Phong Le on 15/06/2021.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var movieDatabase: MovieDatabase?
    
    // Properties
    
    static let identifier = "HomeTableViewCell"
    
    private let nameMovie: UILabel = {
        let nameMovie = UILabel()
        nameMovie.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameMovie.numberOfLines = 0
        return nameMovie
    }()
    
    private let dayReleaseMovie: UILabel = {
        let dayReleaseMovie = UILabel()
        dayReleaseMovie.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        dayReleaseMovie.numberOfLines = 1
        return dayReleaseMovie
    }()
    
    private let imageMovie: UIImageView = {
        let imageMovie = UIImageView()
        imageMovie.clipsToBounds = true
        imageMovie.contentMode = .scaleAspectFill
        return imageMovie
    }()
    
    // Configures
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.nameMovie)
        self.contentView.addSubview(self.dayReleaseMovie)
        self.contentView.addSubview(self.imageMovie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageMovie.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.contentView.frame.size.height - 5,
                                       height: self.contentView.frame.size.height - 5)
        
        self.nameMovie.frame = CGRect(x: self.contentView.frame.size.height + 10,
                                      y: 0,
                                      width: self.contentView.frame.width - self.imageMovie.frame.width - 30,
                                      height: self.contentView.frame.height / 2)
        
        self.dayReleaseMovie.frame = CGRect(x: self.contentView.frame.size.height + 10,
                                            y: self.nameMovie.frame.height,
                                            width: self.contentView.frame.width - self.imageMovie.frame.width - 30,
                                            height: self.contentView.frame.height / 2)
            
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageMovie.image = nil
        self.nameMovie.text = nil
        self.dayReleaseMovie.text = nil
    }
    
    // methods
    
    func configure(movie: Movie) {
        self.nameMovie.text = movie.title
        self.dayReleaseMovie.text = movie.releaseDate
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")") else {
                return
            }
            
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            DispatchQueue.main.async {
                self.imageMovie.image = UIImage(data: data)
            }
        }
    }
    
    
}
