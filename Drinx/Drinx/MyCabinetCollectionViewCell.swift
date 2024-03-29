import UIKit

final class MyCabinetCollectionViewCell: UICollectionViewCell, ProgrammaticView {
    let containerView = UIView()
    let ingredientImageView = UIImageView()
    let ingredientLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupContainerView()
        self.setupImageView()
        self.setupLabelView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup functions
extension MyCabinetCollectionViewCell {
    private func setupContainerView() {
        self.contentView.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    private func setupImageView() {
        self.containerView.addSubview(self.ingredientImageView)
        self.ingredientImageView.contentMode = .scaleAspectFit
        self.ingredientImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ingredientImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        self.ingredientImageView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        self.ingredientImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        self.ingredientImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
    }

    private func setupLabelView() {
        self.containerView.addSubview(self.ingredientLabel)
        self.ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ingredientLabel.heightAnchor.constraint(equalTo: self.containerView.heightAnchor, multiplier: 0.25).isActive = true
        self.ingredientLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        self.ingredientLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        self.ingredientLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        self.ingredientLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.ingredientLabel.textAlignment = .center
        self.ingredientLabel.font = UIFont(name: self.ingredientLabel.font.fontName, size: 24)
    }
}

// MARK: - Utility Functions
extension MyCabinetCollectionViewCell {
    func configure(with ingredient: Ingredient?) {
        guard let ingredient = ingredient else { return }
        self.ingredientImageView.image = ingredient.photoImage
        self.ingredientLabel.text = ingredient.name
    }
}
