//
//  FruitRealm.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import RealmSwift

final class FruitRealm: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isSelected: Bool = false
}
