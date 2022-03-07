//
//  StackView.swift
//  CustomTextFields
//
//  Created by Abdullah on 28/02/2022.
//

import UIKit
class VerticalStackView: UIStackView {
    
    public init(arrangedSubviews: [UIView] = [], spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill) {
        super.init(frame: .zero)
        arrangedSubviews.forEach({addArrangedSubview($0)})
        self.spacing = spacing
        self.axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
