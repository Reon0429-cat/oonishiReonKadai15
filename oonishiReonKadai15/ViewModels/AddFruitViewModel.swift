//
//  AddFruitViewModel.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddFruitViewModelInput {
    func saveButtonDidTapped(fruitNameText: String?)
    func cancelButtonDidTapped()
}

protocol AddFruitViewModelOutput: AnyObject {
    var event: Driver<AddFruitViewModel.Event> { get }
}

protocol AddFruitViewModelType {
    var inputs: AddFruitViewModelInput { get }
    var outputs: AddFruitViewModelOutput { get }
}

final class AddFruitViewModel {
    
    enum Event {
        case returnToPreviousScreen
    }
    private let eventRelay = PublishRelay<Event>()
    
    private let fruitUseCase = FruitUseCase(
        repositry: FruitRepository(
            dataStore: FruitRealmDataStore()
        )
    )
    
}

// MARK: - Input
extension AddFruitViewModel: AddFruitViewModelInput {
    
    func saveButtonDidTapped(fruitNameText: String?) {
        guard let fruitNameText = fruitNameText else { return }
        let fruit = Fruit(name: fruitNameText,
                          isSelected: false)
        fruitUseCase.save(fruit: fruit)
        eventRelay.accept(.returnToPreviousScreen)
    }
    
    func cancelButtonDidTapped() {
        eventRelay.accept(.returnToPreviousScreen)
    }
    
}

// MARK: - Output
extension AddFruitViewModel: AddFruitViewModelOutput {
    
    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    
}

extension AddFruitViewModel: AddFruitViewModelType {
    
    var inputs: AddFruitViewModelInput {
        return self
    }
    
    var outputs: AddFruitViewModelOutput {
        return self
    }
    
}
