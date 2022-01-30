//
//  Chip.swift
//
//
//  Created by Brandon on 29/1/2022.
//

import UIKit

public class Chip: UIView {
    // MARK: - UI Elements
    internal lazy var container: UIView = {
        let value: UIView = UIView()
        value.translatesAutoresizingMaskIntoConstraints = false
        value.layer.borderColor = unselectedBorderColor.cgColor
        value.layer.borderWidth = 2.0 / UIScreen.main.scale
        value.layer.cornerRadius = font.lineHeight
        value.backgroundColor = unselectedBackgroundColor
        return value
    }()
    internal lazy var label: UILabel = {
        let value: UILabel = UILabel()
        value.translatesAutoresizingMaskIntoConstraints = false
        value.backgroundColor = .clear
        value.font = font
        value.textColor = unselectedTintColor
        return value
    }()
    internal lazy var imageView: UIImageView = {
        let value: UIImageView = UIImageView()
        value.translatesAutoresizingMaskIntoConstraints = false
        value.image = selectedImage
        value.tintColor = selectedTintColor
        value.isHidden = true
        value.contentMode = .scaleAspectFit
        return value
    }()

    // MARK: - Data
    public var actionBlock: ActionBlock?
    public var unselectedTintColor: UIColor = .systemBlue
    public var unselectedBackgroundColor: UIColor = .clear
    public var unselectedBorderColor: UIColor = .systemGray
    public var selectedTintColor: UIColor = .white
    public var selectedBackgroundColor: UIColor = .systemBlue
    public var selectedBorderColor: UIColor = .systemBlue
    public var selected: Bool = false {
        didSet {
            container.backgroundColor = selected ? selectedBackgroundColor : unselectedBackgroundColor
            container.layer.borderColor = selected ? selectedBorderColor.cgColor : unselectedBorderColor.cgColor
            label.textColor = selected ? selectedTintColor : unselectedTintColor
            imageView.tintColor = selected ? selectedTintColor : unselectedTintColor
            imageView.isHidden = !selected
            layoutSubviews()
        }
    }
    public var font: UIFont = .systemFont(ofSize: 12.0, weight: .semibold).scaledFont {
        didSet {
            label.font = font
            container.layer.cornerRadius = font.lineHeight
            layoutSubviews()
        }
    }
    public var selectedImage: UIImage? = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate) {
        didSet {
            imageView.image = selectedImage
            layoutSubviews()
        }
    }
    public var text: String? = nil {
        didSet {
            label.text = text
            label.sizeToFit()
            layoutSubviews()
        }
    }
    public var isSelectedImageVisible: Bool {
        return selected && selectedImage != nil
    }

    // MARK: - Constraints
    public var containerConstraints: [NSLayoutConstraint] = []
    public var labelConstraints: [NSLayoutConstraint] = []
    public var imageConstraints: [NSLayoutConstraint] = []

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
        addSubview(container)
        container.addSubview(imageView)
        container.addSubview(label)
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didReceiveTapEvent))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(gestureRecognizer)
    }

    private func setupConstraints() {
        //Clear Constraints
        NSLayoutConstraint.deactivate(containerConstraints)
        NSLayoutConstraint.deactivate(imageConstraints)
        NSLayoutConstraint.deactivate(labelConstraints)
        containerConstraints.removeAll()
        imageConstraints.removeAll()
        labelConstraints.removeAll()

        //Setup Compression
        container.setContentCompressionResistancePriority(.required, for: .vertical)
        container.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        //Setup Card Constraints
        containerConstraints.append(container
            .topAnchor
            .constraint(equalTo: topAnchor))
        containerConstraints.append(container
            .leadingAnchor
            .constraint(equalTo: leadingAnchor))
        containerConstraints.append(container
            .trailingAnchor
            .constraint(equalTo: trailingAnchor))
        containerConstraints.append(container
            .bottomAnchor
            .constraint(equalTo: bottomAnchor))

        //Setup Image Constraints
        if isSelectedImageVisible {
            imageConstraints.append(imageView
                .centerYAnchor
                .constraint(equalTo: container.centerYAnchor))
            imageConstraints.append(imageView
                .trailingAnchor
                .constraint(equalTo: container.trailingAnchor,
                            constant: -.spacing2x))
            imageConstraints.append(imageView
                .heightAnchor
                .constraint(equalToConstant: font.lineHeight))
            imageConstraints.append(imageView
                .widthAnchor
                .constraint(equalToConstant: font.lineHeight))
        }

        //Setup Label Constraints
        labelConstraints.append(label
            .topAnchor
            .constraint(equalTo: container.topAnchor,
                        constant: .spacing2x))
        labelConstraints.append(label
            .leadingAnchor
            .constraint(equalTo: container.leadingAnchor,
                        constant: .spacing2x))
        labelConstraints.append(label
            .trailingAnchor
            .constraint(equalTo: isSelectedImageVisible ? imageView.leadingAnchor : container.trailingAnchor,
                        constant: isSelectedImageVisible ? -.spacing1x : -.spacing2x))
        labelConstraints.append(label
            .bottomAnchor
            .constraint(equalTo: container.bottomAnchor,
                        constant: -.spacing2x))

        //Activate Constraints
        NSLayoutConstraint.activate(containerConstraints)
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(imageConstraints)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    @objc
    private func didReceiveTapEvent() {
        actionBlock?()
    }
}
