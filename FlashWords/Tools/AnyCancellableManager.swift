//
//  AnyCancellableManager.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 04.02.2023.
//

import Foundation
import Combine

final class AnyCancellableManager<T: Any & Hashable> {
    /// Мутабельные словари подписчиков по ключу
    private var observers: [T : AnyCancellable]  = [ : ]
    /// Мутабельные словари с массивами подписчиков по ключу
    private var multitudeObservers: [T : [AnyCancellable]] = [ : ]

    /// Запись одного подписчика по существующему ключу или добавление нового ключа
    func setValue(
        type: T,
        value: AnyCancellable
    ) {
        observers[type]?.cancel()
        observers[type] = value
    }

    /// Перезапись массива подписчиков по существующему ключу или добавление нового ключа
    func setRewriteValues(
        type: T,
        values: [AnyCancellable]
    ) {
        multitudeObservers[type]?.forEach({ $0.cancel() })
        multitudeObservers[type] = values
    }

    /// Добавление новых подписчиков по существующему ключу или добавление нового ключа
    func setUpdateValues(
        type: T,
        values: [AnyCancellable]
    ) {
        if multitudeObservers[type] == nil {
            multitudeObservers[type] = values
        } else {
            multitudeObservers[type]?.append(contentsOf: values)
        }
    }

    /// Отмена и удаление всех подписчиков
    func setCancelAllObservers() {
        observers.forEach { $0.value.cancel() }
        observers.removeAll()
        multitudeObservers.forEach({ $0.value.forEach({ $0.cancel() }) })
        multitudeObservers.removeAll()
    }

    /// Отмена и удаление подписчиков при удалении объекта
    deinit {
        setCancelAllObservers()
    }
}
