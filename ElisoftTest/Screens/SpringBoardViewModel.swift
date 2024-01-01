//
//  SpringBoardViewModel.swift
//  ElisoftTest
//
//  Created by Quan on 28/12/2023.
//

import Foundation
class SpringBoardViewModel {
    
    var listImgPath: [String] = []
    let imgPath: String = "http://loremflickr.com/200/200/"
    
    var dataSourceDidChange: (() -> Void)?
    var dataSrouceDidReset: (() -> Void)?
    
    init() {
        reloadDataSourceImgPath()
    }
    
    func handleAddAction() {
        let newIndex = listImgPath.count + 1
        let newElement = generateImagePath(index: newIndex)
        listImgPath.append(newElement)
        dataSourceDidChange?()
    }
    
    func handleRefreshAction() {
        reloadDataSourceImgPath()
        dataSrouceDidReset?()
    }
    
    private func reloadDataSourceImgPath() {
        listImgPath.removeAll()
        for index in 1...140 {
            let newElement = generateImagePath(index: index)
            listImgPath.append(newElement)
        }
    }
    
    private func generateImagePath(index: Int) -> String {
        let randomId = 1 + arc4random_uniform(300)
        return "http://loremflickr.com/200/200/\(randomId)\(index)"
    }
}
