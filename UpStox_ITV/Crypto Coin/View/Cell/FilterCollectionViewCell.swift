//
//  FilterCollectionViewCell.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    // UILabel to display the filter's title
    private lazy var lblFilterTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    // UIImageView to display a checkmark when the filter is selected
    private lazy var selectedCheckImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .black
        return imageView
    }()
    
    // UIStackView to arrange the checkmark and the filter title horizontally
    private lazy var StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectedCheckImage, lblFilterTitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    // Initialization method when creating the cell programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(StackView)
        self.setupConstraints()
    }
    
    // Initialization method when the cell is created from a storyboard or XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(StackView)
    }
    
    // Function to set up Auto Layout constraints for subviews
    private func setupConstraints() {
        
        // Constraints for the selectedCheckImage (checkmark icon)
        NSLayoutConstraint.activate([
            selectedCheckImage.widthAnchor.constraint(equalToConstant: 15),
            selectedCheckImage.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        // Constraints for the StackView (arranged view for checkmark and title label)
        NSLayoutConstraint.activate([
            self.StackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            self.StackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            self.StackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            self.StackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])        
        
        self.contentView.applyDefaultStyle()
    }
    
    // Function to populate the cell with data from a FilterOptions model
    func loadCell(filter: FilterOptions) {
        self.lblFilterTitle.text = filter.title
        self.selectedCheckImage.isHidden = !filter.isSelected
        self.contentView.backgroundColor = !(filter.isSelected) ? .white : .lightGray
    }
}

