//
//  MainViewModel.swift
//  LabelSample
//
//  Created by Taewan_MacBook on 2022/01/15.
//

import Foundation

class MainViewModel {
    var userInputBuffer: String?
    private var textSampleList: [String] = []
    var numOfTableViewSection: Int = 1
    
    /// Number of tableView rows in section
    /// - Parameter section: section index
    /// - Returns: num of rows
    func getNumOfRows(in section: Int) -> Int {
        return textSampleList.count
    }
    
    func getTableViewIdentifier(at section: Int, row: Int) -> String? {
        return "LABEL"
    }
    
    func getTableViewRowData(section: Int, row: Int) -> String? {
        let listCount = textSampleList.count
        let index = listCount - row - 1
        if index >= listCount || index < 0 {
            return nil
        }
        return textSampleList[index]
    }
    
    func removeUserInputList(section: Int, row: Int, completion: @escaping () -> Void) {
        let listCount = textSampleList.count
        let index = listCount - row - 1
        if index >= listCount || index < 0 {
            return
        }
        textSampleList.remove(at: index)
        completion()
    }
    
    func addUserInputList(completion: @escaping () -> Void, listUpdated: @escaping () -> Void) {
        completion()
        guard let buffer = userInputBuffer else { return }
        self.textSampleList.append(buffer)
        
        userInputBuffer = nil
        listUpdated()
    }
}
