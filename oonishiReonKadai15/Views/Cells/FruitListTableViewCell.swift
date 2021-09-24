//
//  FruitListTableViewCell.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import UIKit

final class FruitListTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var checkmarkButton: UIButton!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    func configure(fruit: Fruit) {
        nameLabel.text = fruit.name
        checkmarkButton.imageView?.isHidden = !fruit.isSelected
    }
    
}
