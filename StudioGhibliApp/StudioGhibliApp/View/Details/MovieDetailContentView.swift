import UIKit

class MovieDetailContentView: UIView {

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let directorNameLabel = UILabel()
    private let runningTimeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let errorLabel = UILabel()
    private var skeletonViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        showSkeleton()
        setupErrorLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        showSkeleton()
        setupErrorLabel()
    }
    
    private func setupViews() {
        [posterImageView, titleLabel, releaseDateLabel,
         directorNameLabel, runningTimeLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        
        releaseDateLabel.font = .systemFont(ofSize: 20)
        releaseDateLabel.numberOfLines = 0
        
        runningTimeLabel.font = .systemFont(ofSize: 20)
        runningTimeLabel.numberOfLines = 0
     
        directorNameLabel.font = .systemFont(ofSize: 16)
        directorNameLabel.numberOfLines = 0
        
        runningTimeLabel.font = .systemFont(ofSize: 16)
        runningTimeLabel.numberOfLines = 0
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Não foi possível exibir os dados!"
        errorLabel.textColor = .systemRed
        errorLabel.font = .boldSystemFont(ofSize: 20)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            posterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 252),
            posterImageView.widthAnchor.constraint(equalToConstant: 176),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            runningTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            runningTimeLabel.leadingAnchor.constraint(equalTo: releaseDateLabel.trailingAnchor, constant: 12),
            
            directorNameLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            directorNameLabel.leadingAnchor.constraint(equalTo: releaseDateLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: directorNameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
    
    func showSkeleton() {
        let skeletonColor = UIColor.systemGray5
        
        [posterImageView, titleLabel, releaseDateLabel,
         directorNameLabel, runningTimeLabel, descriptionLabel].forEach { view in
            let skeleton = UIView()
            skeleton.translatesAutoresizingMaskIntoConstraints = false
            skeleton.backgroundColor = skeletonColor
            skeleton.layer.cornerRadius = 6
            skeleton.clipsToBounds = true
            addSubview(skeleton)
            skeletonViews.append(skeleton)
            
            NSLayoutConstraint.activate([
                skeleton.topAnchor.constraint(equalTo: view.topAnchor),
                skeleton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                skeleton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                skeleton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    func hideSkeleton() {
        skeletonViews.forEach { $0.removeFromSuperview() }
        skeletonViews.removeAll()
    }
    
    func configure(with model: MovieViewModel?) {
        guard let model = model else {
            showErrorMessage()
            return
        }
        
        errorLabel.isHidden = true
        [posterImageView, titleLabel, releaseDateLabel,
         directorNameLabel, runningTimeLabel, descriptionLabel].forEach {
            $0.isHidden = false
        }
        
        titleLabel.text = model.title
        releaseDateLabel.text = model.releaseDate
        runningTimeLabel.text = model.runningTime
        directorNameLabel.text = model.producer
        descriptionLabel.text = model.description
        
        if let url = model.imageURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = image
                        self.hideSkeleton()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideSkeleton()
                    }
                }
            }
        } else {
            hideSkeleton()
        }
    }
    
    func showErrorMessage() {
        errorLabel.isHidden = false
        hideSkeleton()
        
        [posterImageView, titleLabel, releaseDateLabel,
         directorNameLabel, runningTimeLabel, descriptionLabel].forEach {
            $0.isHidden = true
        }
    }
}
