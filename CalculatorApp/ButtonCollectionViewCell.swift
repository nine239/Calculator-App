//
//  ButtonCollectionViewCell.swift
//  CalculatorApp
//
//  Created by Nguyen Tuan Vinh on 6/9/25.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "ButtonCollectionViewCell"
    
    private var calculatorButton : CalculatorButton!
    
    private var titleLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        label.text = "..."
        return label
    }()
    
    public func configure(with calculatorButton : CalculatorButton){
        self.calculatorButton = calculatorButton
        self.titleLabel.text = calculatorButton.title
        self.backgroundColor = calculatorButton.color
        
//        if calculatorButton.title == "0"{
//            self.layer.cornerRadius = self.frame.size.height / 2
//        }
//        else{
//            self.layer.cornerRadius = self.frame.size.width / 2
//        }
//        
//        self.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        
        // Set contrainst for titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        self.layer.cornerRadius = self.frame.size.height / 2
        
    }
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
