//
//  BoardCollectionViewCell.swift
//  ElisoftTest
//
//  Created by Quan on 29/12/2023.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var listImgPath: [String] = []
    var numberOfColumns: Int = 0
    var numberOfRows: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "SpringBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpringBoardCollectionViewCell")
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCollectionViewCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
    }
    
    func configBoardCell(imgPaths: [String], totalColumns: Int, totalRows: Int) {
        listImgPath = imgPaths
        numberOfRows = totalRows
        numberOfColumns = totalColumns
        collectionView.reloadData()
    }
}

extension BoardCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows * numberOfColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row < listImgPath.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpringBoardCollectionViewCell", for: indexPath) as! SpringBoardCollectionViewCell
            
            let item = listImgPath[indexPath.row]
            cell.configCell(imgPath: item)
            return cell
        } else {
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
            return emptyCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height
        
        let itemWidth = collectionViewWidth / CGFloat(numberOfColumns)
        let itemHeight = collectionViewHeight / CGFloat(numberOfRows)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

