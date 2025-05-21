import UIKit

class MovieItemView: UIView {

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    // MARK: - private methods
    private func setupViews() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 4
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        
        yearLabel.font = UIFont.systemFont(ofSize: 12)
        yearLabel.textColor = .darkGray
        yearLabel.numberOfLines = 1
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(yearLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            yearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            yearLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            yearLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - public methods
    func configure(_ model: MovieViewData) {
        removeShimmer(from: posterImageView)
        removeShimmer(from: titleLabel)
        removeShimmer(from: yearLabel)
        
        titleLabel.textColor = .label
        titleLabel.backgroundColor = .clear
        titleLabel.layer.cornerRadius = 0
        titleLabel.layer.masksToBounds = false
        
        yearLabel.textColor = .secondaryLabel
        yearLabel.backgroundColor = .clear
        yearLabel.layer.cornerRadius = 0
        yearLabel.layer.masksToBounds = false
        
        posterImageView.backgroundColor = .clear
        
        titleLabel.text = model.title
        yearLabel.text = model.releaseDate
        
        guard let url = model.imageURL else {
            posterImageView.image = nil
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }.resume()
    }
    
    func showPlaceholder() {
        posterImageView.image = nil
        posterImageView.backgroundColor = .systemGray3
        applyShimmer(to: posterImageView)
        
        titleLabel.text = "      "
        titleLabel.backgroundColor = .systemGray5
        titleLabel.layer.cornerRadius = 4
        titleLabel.layer.masksToBounds = true
        titleLabel.textColor = .clear
        applyShimmer(to: titleLabel)
        
        yearLabel.text = "   "
        yearLabel.backgroundColor = .systemGray5
        yearLabel.layer.cornerRadius = 4
        yearLabel.layer.masksToBounds = true
        yearLabel.textColor = .clear
        applyShimmer(to: yearLabel)
    }
}
