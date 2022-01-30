//
//  ChipCarousel.swift
//
//
//  Created by Brandon on 29/1/2022.
//

import SnapKit
import UIKit

public class ChipCarousel: UIView {
    // MARK: - UI Elements
    private var scrollView: UIScrollView = {
        let value: UIScrollView = UIScrollView()
        value.backgroundColor = .clear
        value.contentInsetAdjustmentBehavior = .never
        value.contentInset = .zero
        value.showsHorizontalScrollIndicator = false
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    // MARK: - Data
    private var items: [ChipItem] = [] {
        didSet {
            setItems(items)
        }
    }
    public var font: UIFont = .systemFont(ofSize: 12.0, weight: .semibold).scaledFont {
        didSet {
            setItems(items)
        }
    }

    // MARK: - Constraints
    private var scrollViewConstraints: [NSLayoutConstraint] = []

    // MARK: - Lifecycle
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        isUserInteractionEnabled = true
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        addSubview(scrollView)
    }

    private func setupConstraints() {
        // Deactivate Constraints
        NSLayoutConstraint.deactivate(scrollViewConstraints)
        scrollViewConstraints.removeAll()

        // Setup Collection View Constraints
        scrollViewConstraints.append(scrollView
            .topAnchor
            .constraint(equalTo: topAnchor))
        scrollViewConstraints.append(scrollView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor))
        scrollViewConstraints.append(scrollView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor))
        scrollViewConstraints.append(scrollView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor))
        scrollViewConstraints.append(scrollView
            .heightAnchor
            .constraint(equalToConstant: font.lineHeight + .spacing6x))

        // Activate Constraints
        NSLayoutConstraint.activate(scrollViewConstraints)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        setupConstraints()
    }
}

public extension ChipCarousel {
    func setItems(_ items: [ChipItem]) {
        // Reset View
        scrollView.subviews.forEach({$0.removeFromSuperview()})
        
        // Add Chips
        var lastView: UIView?
        for (index, item) in items.enumerated() {
            let view: Chip = Chip()
            view.unselectedTintColor = item.unselectedTintColor
            view.unselectedBackgroundColor = item.unselectedBackgroundColor
            view.unselectedBorderColor = item.unselectedBorderColor
            view.selectedTintColor = item.selectedTintColor
            view.selectedBackgroundColor = item.selectedBackgroundColor
            view.selectedBorderColor = item.selectedBorderColor
            view.selected = item.selected
            view.font = font
            view.selectedImage = item.selectedImage
            view.text = item.text
            view.actionBlock = item.actionBlock
            scrollView.addSubview(view)
            view.snp.remakeConstraints { make in
                make.top.bottom.equalToSuperview()
                if lastView == nil {
                    make.left.equalToSuperview()
                } else {
                    make.left.equalTo(lastView?.snp.right ?? 0).offset(CGFloat.spacing2x)
                }
                if index == items.endIndex - 1 {
                    make.right.lessThanOrEqualToSuperview()
                }
            }
            lastView = view
        }
    }
}
