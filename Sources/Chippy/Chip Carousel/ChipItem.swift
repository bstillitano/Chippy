//
//  File.swift
//
//
//  Created by Brandon on 29/1/2022.
//

import Foundation
import UIKit

public struct ChipItem {
    public init() { }

    public var unselectedTintColor: UIColor = .systemBlue
    public var unselectedBackgroundColor: UIColor = .clear
    public var unselectedBorderColor: UIColor = .systemGray
    public var selectedTintColor: UIColor = .white
    public var selectedBackgroundColor: UIColor = .systemBlue
    public var selectedBorderColor: UIColor = .systemBlue
    public var selected: Bool = false
    public var selectedImage: UIImage? = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
    public var text: String = ""
    public var actionBlock: ActionBlock?
}
