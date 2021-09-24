//
//  FruitRepository.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RxSwift

protocol FruitRepositoryProtocol {
    func save(fruit: Fruit) -> Completable
    func loadAllFruits() -> Single<[Fruit]>
    func update(fruit: Fruit, at index: Int) -> Completable
}

final class FruitRepository: FruitRepositoryProtocol {
    
    private let dataStore: FruitDataStoreProtocol
    init(dataStore: FruitDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func save(fruit: Fruit) -> Completable {
        dataStore.save(fruit: fruit)
        return .empty()
    }
    
    func loadAllFruits() -> Single<[Fruit]> {
        return .just(dataStore.loadAllFruits())
    }
    
    func update(fruit: Fruit, at index: Int) -> Completable {
        dataStore.update(fruit: fruit, at: index)
        return .empty()
    }
    
}
