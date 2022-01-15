//
//  TableViewCell.swift
//  LabelSample
//
//  Created by Taewan_MacBook on 2022/01/16.
//

import UIKit

protocol SampleTableViewCellDelegate: class {
    func deleteCell(at row: Int, section: Int)
}

enum TableViewCellMode {
    case normal
    case delete
}

class MainTableViewCell: UITableViewCell {
    var isSwipeInActive: Bool = false
    var section: Int = 0
    var swipeGesture: UIPanGestureRecognizer?
    var delegate: SampleTableViewCellDelegate?
    var mode: TableViewCellMode = .normal {
        didSet {
            switch mode {
            case .normal : deleteButtonWidthConstraint.constant = 0
            case .delete : deleteButtonWidthConstraint.constant = deleteButtonMaxSize
            }
        }
    }
    
    var deleteButtonMaxSize: CGFloat {
        get {
            return deleteButton.intrinsicContentSize.width + deleteButton.titleEdgeInsets.left + deleteButton.titleEdgeInsets.right
        }
    }
    
    var deleteButtonWidthConstraint: NSLayoutConstraint!
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.55), for: .highlighted)
        button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.55)
        button.addTarget(self, action: #selector(deleteButtonTouchUpInside), for: .touchUpInside)
        contentView.addSubview(button)
        return button
    } ()
    
    lazy var attributeLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.linkEnabled = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mode = .normal
        attributeLabel.prepareForReuse()
        isSwipeInActive = false
    }
    
    @objc private func deleteButtonTouchUpInside() {
        delegate?.deleteCell(at: tag, section: section)
    }
    
    @objc private func panGestureSwipeHandler(gesture: UIPanGestureRecognizer) {
        let state = gesture.state
        let velocity = gesture.velocity(in: contentView).x
        if abs(velocity) < abs(gesture.velocity(in: contentView).y) {
            return
        }
        let threshold: CGFloat = 500
        let removingTriggerThreshold: CGFloat = 1000
        if state == .ended {
            if velocity > removingTriggerThreshold {
                deleteButtonWidthConstraint.constant = deleteButtonMaxSize
                delegate?.deleteCell(at: tag, section: section)
                return
            }
            else if velocity > threshold {
                deleteButtonWidthConstraint.constant = deleteButtonMaxSize
            }
            else if -velocity > threshold {
                deleteButtonWidthConstraint.constant = 0
            }
            else if deleteButtonWidthConstraint.constant >= deleteButtonMaxSize / 2 {
                deleteButtonWidthConstraint.constant = deleteButtonMaxSize
            }
            else {
                deleteButtonWidthConstraint.constant = 0
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            })
            return
        }
        let targetWidth = deleteButtonWidthConstraint.constant + velocity * 0.01
        deleteButtonWidthConstraint.constant = max(0, min(targetWidth, deleteButtonMaxSize))
    }
    
    func bindData(text: String?) {
        attributeLabel.setAttributedText(text: text)
    }
    
    private func setConstraints() {
        deleteButtonWidthConstraint = NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButtonWidthConstraint
        ])
        
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.layer.cornerRadius = 8
        wrapper.backgroundColor = .white
        contentView.addSubview(wrapper)
        wrapper.addSubview(attributeLabel)
        NSLayoutConstraint.activate([
            wrapper.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 20),
            wrapper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            wrapper.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            wrapper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            attributeLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 10),
            attributeLabel.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -10),
            attributeLabel.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 10),
            attributeLabel.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -10)
        ])
    }
    
}
