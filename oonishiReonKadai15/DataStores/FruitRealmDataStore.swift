//
//  FruitRealmDataStore.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RealmSwift

protocol FruitDataStoreProtocol {
    func save(fruit: Fruit)
    func loadAllFruits() -> [Fruit]
    func update(fruit: Fruit)
}

final class FruitRealmDataStore: FruitDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<FruitRealm> {
        realm.objects(FruitRealm.self)
    }
    
    func save(fruit: Fruit) {
        let fruitRealm = FruitRealm(fruit: fruit)
        try! realm.write {
            realm.add(fruitRealm)
        }
    }
    
    func loadAllFruits() -> [Fruit] {
        return objects.map { Fruit(fruitRealm: $0) }
    }
    
    func update(fruit: Fruit) {
        // アプリのロジックに問題がなければ必ず取得できるはず
        let object = realm.object(ofType: FruitRealm.self, forPrimaryKey: fruit.uuidString)!

        try! realm.write {
            object.name = fruit.name
            object.isSelected = fruit.isSelected
        }
    }
    
}

private extension Fruit {
    
    init(fruitRealm: FruitRealm) {
        self.name = fruitRealm.name
        self.isSelected = fruitRealm.isSelected
        self.uuidString = fruitRealm.uuidString
    }
    
}

private extension FruitRealm {
    
    convenience init(fruit: Fruit) {
        self.init()
        self.name = fruit.name
        self.isSelected = fruit.isSelected
        self.uuidString = fruit.uuidString
    }
    
}
