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
        guard let identifier = viewModel.getTableViewIdentifier(at: indexPath.section, row: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MainTableViewCell else {
                  return UITableViewCell()
              }
        
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        cell.swipeGesture?.delegate = self
        cell.bindData(text: viewModel.getTableViewRowData(section: indexPath.section, row: indexPath.row))
        cell.delegate = self
        return cell
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MainViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        (textView as? TextView)?.togglePlaceHolder(isHidden: !(textView.text?.isEmpty ?? false))
        viewModel.userInputBuffer = textView.text
    }
}

extension MainViewController: SampleTableViewCellDelegate {
    func deleteCell(at row: Int, section: Int) {
        viewModel.removeUserInputList(section: section, row: row, completion: {
            self.textView.text = nil
            self.tableView.performBatchUpdates({
                self.tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .right)
            }, completion: { _ in
                self.tableView.reloadData()
            })
        })
    }
}
