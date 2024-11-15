//
//  FilterView.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import UIKit

class FilterView: UIView {
    
    var doneButtonTapped: (([FilterOptions]) -> Void)?
    private var view: UIView!
    private var bottomConstraint: NSLayoutConstraint!
    
    private lazy var collectionView: UICollectionView = {
        let layout = FlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 2.0, bottom: 10, right: 2.0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 50, width: self.frame.width, height: 10), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 21, bottom: 10, right: 21)
        collectionView.backgroundColor = .clear
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    // title: This is a string that represents the name of the filter, such as "Active Coins" or "Only Tokens."
    // isSelected: A boolean flag that tells whether the filter is currently selected (defaults to false).
    // mapIndex: An integer that helps group related filters. This property indicates that filters with the same mapIndex should not be selected at the same time. The map index essentially helps to create "groups" of filters where only one can be selected at a time.
    private var filtersList: [FilterOptions] = [
        FilterOptions(title: StringMessage.activeCoins.value, mapIndex: 1),
        FilterOptions(title: StringMessage.inactiveCoins.value, mapIndex: 1),
        FilterOptions(title: StringMessage.onlyTokens.value, mapIndex: 2),
        FilterOptions(title: StringMessage.onlyCoins.value, mapIndex: 2),
        FilterOptions(title: StringMessage.newCoins.value, mapIndex: 3)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.view = UIView()
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.layer.cornerRadius = 10
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .lightGray
        self.addSubview(self.view)
        
        let buttonDone = UIButton(type: .system)
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.setTitleColor(.black, for: .normal)
        buttonDone.translatesAutoresizingMaskIntoConstraints = false
        buttonDone.titleLabel?.textAlignment = .right
        buttonDone.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonDone.addTarget(self, action: #selector(onClickDone(_:)), for: .touchUpInside)
        self.view.addSubview(buttonDone)
        
        self.view.addSubview(collectionView)
        self.bottomConstraint = self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 200)
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomConstraint!,
            self.view.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            buttonDone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            buttonDone.topAnchor.constraint(equalTo: view.topAnchor),
            buttonDone.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: buttonDone.bottomAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
        
        self.reloadCollectionVw()
    }
    
    // Applied filteres based on user filter selections.
    @objc private func onClickDone(_ sender: UIButton) {
        let selectedFilters = self.filtersList.filter({ $0.isSelected })
        self.doneButtonTapped?(selectedFilters)
    }
    
    private func reloadCollectionVw() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // Reset the filter with default values.
    func resetFilter() {
        self.filtersList = self.filtersList.map({ obj in
            let object = obj
            object.isSelected = false
            return object
        })
        self.reloadCollectionVw()
    }

    func performAnimation(isHide: Bool, animations: (() -> Void)? = nil) {
        self.bottomConstraint.constant = isHide ? 200 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            animations?()
        })
    }
}

extension FilterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filtersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        guard let filter = self.filtersList[safe: indexPath.item] else { return UICollectionViewCell() }
        cell.loadCell(filter: filter)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = self.filtersList[safe: indexPath.item] else { return }
        let mapIndexValue = selectedItem.mapIndex
        if selectedItem.isSelected {
            self.filtersList[safe: indexPath.item]?.isSelected = false
            self.reloadCollectionVw()
            return
        }
        
        for (index, item) in self.filtersList.enumerated() {
            if item.mapIndex == mapIndexValue {
                self.filtersList[index].isSelected = false
            }
        }
        
        self.filtersList[safe: indexPath.item]?.isSelected = true
        self.reloadCollectionVw()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.boldSystemFont(ofSize: 16)
        let filterText = self.filtersList[indexPath.item]
        let textSize = (filterText.title as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        let imageWidth = (filterText.isSelected) ? 20 : 0
        let leftRightPaddingSpace = 16
        let verticalHorizontalSpace = 4
        return CGSize(width: textSize.width + CGFloat(imageWidth) + CGFloat(leftRightPaddingSpace) + CGFloat(verticalHorizontalSpace), height: 30)
    }
}
