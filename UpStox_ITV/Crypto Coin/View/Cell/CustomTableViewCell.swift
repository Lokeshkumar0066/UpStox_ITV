//
//  CustomTableViewCell.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // UILabel for displaying the Name text
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    // UILabel for displaying the Symbols
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // UIImageView for displaying an icon based on the given conditions
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12.5
        return imageView
    }()
    
    // UIImageView for displaying a tag icon (e.g., a "tag" image)
    private lazy var tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // UIStackView to arrange the top and bottom labels vertically
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    // UIView for displaying a separator line at the bottom of the cell
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    // Initialization method when creating the cell programmatically
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(labelsStackView)
        contentView.addSubview(tagImageView)
        contentView.addSubview(rightImageView)
        contentView.addSubview(separatorView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Function to set up Auto Layout constraints for the subviews
    private func setupConstraints() {
        // Constraints for the labelsStackView (topLabel and bottomLabel stacked vertically)
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            labelsStackView.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -10)
        ])
        
        // Constraints for the tagImageView (tag icon)
        NSLayoutConstraint.activate([
            tagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            tagImageView.widthAnchor.constraint(equalToConstant: 25),
            tagImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        // Constraints for the rightImageView
        NSLayoutConstraint.activate([
            rightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            rightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: 25),
            rightImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        // Constraints for the separatorView (bottom separator line)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // Function to populate the cell with data from a CoinResponeModel object
    func loadCell(item: CoinResponeModel) {
        self.topLabel.text = item.name
        self.bottomLabel.text = item.symbol
        self.tagImageView.isHidden = !item.isTagShown
        self.tagImageView.image = (item.isTagShown) ? UIImage(named: "tag") : nil
        self.rightImageView.backgroundColor = item.bgColor
        if let imageName = item.imageName, !imageName.isEmpty {
            self.rightImageView.image = UIImage(named: imageName)
        } else {
            self.rightImageView.image = nil
            self.tagImageView.isHidden = true
            self.tagImageView.image = nil
        }
        self.contentView.backgroundColor = item.isActive ? .white : UIColor(named: "disabledColor")
    }
}

