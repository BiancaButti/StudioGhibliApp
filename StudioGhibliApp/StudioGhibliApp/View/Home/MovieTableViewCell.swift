import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private let movieItemView = MovieItemView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        movieItemView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieItemView)
        
        NSLayoutConstraint.activate([
            movieItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupLayout() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    func configure(with model: MovieViewData) {
        movieItemView.configure(model)
    }
    
    func showPlaceholder() {
        movieItemView.showPlaceholder()
    }
}
