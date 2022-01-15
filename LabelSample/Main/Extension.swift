//
//  Extension.swift
//  LabelSample
//
//  Created by Taewan_MacBook on 2022/01/16.
//

import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numOfTableViewSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let id = viewModel.getTableViewIdentifier(at: indexPath.section, row: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? MainTableViewCell else
    }
}
