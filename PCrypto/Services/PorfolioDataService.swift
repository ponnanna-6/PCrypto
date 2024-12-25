//
//  PorfolioDataService.swift
//  PCrypto
//
//  Created by Logycent on 25/12/2024.
//

import CoreData
import Foundation

class PorfolioDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"

    @Published var savedEntities: [PortfolioEntity] = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading core data: \(error)")
            }
            self.getPortfolio()
        }
    }

    //MARK: PUBLIC SECTON
    func update(coin: CoinModel, amount: Double) {
        if let entity = savedEntities.first(where: { (savedEntity) -> Bool in
            return savedEntity.coinId == coin.id
        }) {
            if amount > 0 {
                updateEntity(entity: entity, amount: amount)
            } else {
                deleteEntity(entity: entity)
            }
        } else {
            addEntity(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE SECTION

    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio entities: \(error)")
        }
    }

    private func addEntity(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
    }

    private func updateEntity(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }

    private func deleteEntity(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    private func saveEntity() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving entity: \(error)")
        }
    }

    private func applyChanges() {
        saveEntity()
        getPortfolio()
    }
}
