//
//  SpringBoardViewController.swift
//  ElisoftTest
//
//  Created by Quan on 28/12/2023.
//

import UIKit
import SDWebImage

class SpringBoardViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: SpringBoardViewModel = SpringBoardViewModel()
    
    
    let screenTitle: String = "SpringBoard"
    var boardDatasource: [[String]] = []
    let numberOfRows: Int = 10
    let numberOfColumns: Int = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        addActionButtons()
        setupCollectionView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.dataSourceDidChange = { [weak self] in
            guard let self = self else { return }
            self.updatePageCount()
            let itemPerPage: Int = self.numberOfRows * self.numberOfColumns
            let currentPageCount = self.boardDatasource.count
            self.boardDatasource = self.generateBoardDatasource(listTotalData: viewModel.listImgPath, itemsPerSubArray: itemPerPage)
            let section = self.boardDatasource.count - 1
            if currentPageCount == self.boardDatasource.count {
                self.collectionView.reloadSections([section])
            } else {
                self.collectionView.insertSections([section])
            }
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: section), at: .right, animated: true)
            
        }
        
        viewModel.dataSrouceDidReset = { [weak self] in
            guard let self = self else { return }
            self.updatePageCount()
            self.pageControl.currentPage = 0
            let itemPerPage: Int = self.numberOfRows * self.numberOfColumns
            self.boardDatasource = self.generateBoardDatasource(listTotalData: viewModel.listImgPath, itemsPerSubArray: itemPerPage)
            self.resetCollectionView()
        }
    }
    
    private func resetCollectionView() {
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SDImageCache.shared.clearMemory()
            SDWebImageManager.shared.cancelAll()
            self.collectionView.reloadData()
        }
    }
    
    private func addActionButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .white
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        refreshButton.tintColor = .white
        
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }
    
    private func configUI() {
        pageControl.currentPage = 0
        boardDatasource = generateBoardDatasource(listTotalData: viewModel.listImgPath, itemsPerSubArray: numberOfRows * numberOfColumns)
        updatePageCount()
        navigationItem.title = screenTitle
    }
    
    private func generateBoardDatasource(listTotalData: [String], itemsPerSubArray: Int) -> [[String]] {
        var separatedLists: [[String]] = []
        for index in stride(from: 0, to: listTotalData.count, by: itemsPerSubArray) {
            let endIndex = Swift.min(index + itemsPerSubArray, listTotalData.count)
            let sublist = Array(listTotalData[index..<endIndex])
            separatedLists.append(sublist)
        }
        return separatedLists
    }
    
    @objc func addButtonTapped() {
        viewModel.handleAddAction()
    }
    
    @objc func refreshButtonTapped() {
        viewModel.handleRefreshAction()
    }
    
    private func updatePageCount() {
        let totalItems = viewModel.listImgPath.count
        let itemsPerPage = numberOfRows * numberOfColumns
        
        let totalPages = (totalItems + itemsPerPage - 1) / itemsPerPage
        pageControl.numberOfPages = totalPages
    }
    
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        collectionView.register(UINib(nibName: "BoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BoardCollectionViewCell")
    }
}

extension SpringBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return boardDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionViewCell", for: indexPath) as! BoardCollectionViewCell
        
        let listItems = boardDatasource[indexPath.section]
        cell.configBoardCell(imgPaths: listItems, totalColumns: numberOfColumns, totalRows: numberOfRows)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = currentPage
    }
}
