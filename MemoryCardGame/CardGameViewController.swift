//
//  ViewController.swift
//  MemoryCardGame
//
//  Created by Kushagra Goyal on 08/01/25.
//

import UIKit

// Easy -> 4x2
// Medium -> 4x4
// Hard -> 4x6

class CardGameViewController: UIViewController {
    
    private var cardCollectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width - 20
        layout.itemSize = CGSize(width: screenWidth / 4 - 10, height: 110)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell().identifier)
        return view
    }()
    
    var viewModel = CardGameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardCollectionView)
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        addConstraints()
    }
    
    private func addConstraints() {
        let cardCollectionViewConstraints = [
            cardCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cardCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cardCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cardCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ]
        
        NSLayoutConstraint.activate(cardCollectionViewConstraints)
    }
}

extension CardGameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell().identifier, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .blue
        cell.cardlabel.text = viewModel.cardArray[indexPath.row].value
        cell.cardlabel.isHidden = !viewModel.cardArray[indexPath.row].isFLipped
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.cardDidTapped(at: indexPath.row)
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.viewModel.checkIfMatchFound(at: indexPath.row)
            collectionView.reloadData()
        }
    }
}
