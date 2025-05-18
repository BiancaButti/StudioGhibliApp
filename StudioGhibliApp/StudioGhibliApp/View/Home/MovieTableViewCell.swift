import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private let movieItemView = MovieItemView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        movieItemView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieItemView)
        
        NSLayoutConstraint.activate([
            movieItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with model: MovieViewModel) {
        movieItemView.configure(model)
    }
}
