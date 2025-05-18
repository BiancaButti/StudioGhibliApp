import UIKit

class MovieDetailContentView: UIView {

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

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
    
    private func setupViews() {
        [posterImageView, titleLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            posterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 252),
            posterImageView.widthAnchor.constraint(equalToConstant: 176),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
    
    func configure(with model: MovieViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        if let url = model.imageURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = image
                    }
                }
            }
        }
    }
}
