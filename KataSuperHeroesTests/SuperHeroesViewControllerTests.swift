//
//  SuperHeroesViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesViewControllerTests: AcceptanceTestCase {

    private let repository = MockSuperHeroesRepository()

    func testShowsEmptyCaseIfThereAreNoSuperHeroes() {
        givenThereAreNoSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForViewWithAccessibilityLabel("¯\\_(ツ)_/¯")
    }
    
    func testDoesNotShowEmptyCaseIfThereAreSuperHeroes() {
        givenThereAreSomeSuperHeroes()
        
        openSuperHeroesViewController()
        
        tester().waitForAbsenceOfViewWithAccessibilityLabel("¯\\_(ツ)_/¯")
    }
    
    func testShowsTheNumberOfSuperHeroes(){
        givenThereAreSomeSuperHeroes()
        
        openSuperHeroesViewController()
        
        let tableView = tester().waitForViewWithAccessibilityLabel("SuperHeroesTableView") as! UITableView
        
        expect(tableView.numberOfRowsInSection(0)).to(equal(10))
    }
    
    func testShowSuperHeroesName () {
        givenThereAreSomeSuperHeroes(10)
        
        openSuperHeroesViewController()
        
        for i in 0..<10 {
            let cell = tester().waitForViewWithAccessibilityLabel("SuperHero - \(i)") as! SuperHeroTableViewCell
            expect(cell.nameLabel.text).to(equal("SuperHero - \(i)"))
        }
    }
    
    func testTapOnAvengerWillNavigateToAvengerDetail () {
//        givenThereAreSomeSuperHeroes()
//        
//        openSuperHeroesViewController()
//        
//        let tableView = tester().waitForViewWithAccessibilityLabel("SuperHeroesTableView") as! UITableView
//        
//        for i in 0..<10 {
//        let index = i
//        
//        let name = "SuperHero - \(index)"
//
//        tester().tapRowAtIndexPath(NSIndexPath(forRow:index, inSection:0), inTableView: tableView)
//        tester().waitForViewWithAccessibilityLabel("Name - \(name)")
//        }
        
        let superHeroIndex = 1
        let superHeroes = givenThereAreSomeSuperHeroes()
        let superHero = superHeroes[superHeroIndex]
        openSuperHeroesViewController()
        
        tester().waitForViewWithAccessibilityLabel(superHero.name)
        tester().tapRowAtIndexPath(NSIndexPath(forRow: superHeroIndex, inSection: 0),
                                   inTableViewWithAccessibilityIdentifier: "SuperHeroesTableView")
        
        tester().waitForViewWithAccessibilityLabel(superHero.name)
    }

    private func givenThereAreNoSuperHeroes() {
        givenThereAreSomeSuperHeroes(0)
    }

    private func givenThereAreSomeSuperHeroes(numberOfSuperHeroes: Int = 10,
        avengers: Bool = false) -> [SuperHero] {
        var superHeroes = [SuperHero]()
        for i in 0..<numberOfSuperHeroes {
            let superHero = SuperHero(name: "SuperHero - \(i)",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg"),
                isAvenger: avengers, description: "Description - \(i)")
            superHeroes.append(superHero)
        }
        repository.superHeroes = superHeroes
        return superHeroes
    }

    private func openSuperHeroesViewController() {
        let superHeroesViewController = ServiceLocator()
            .provideSuperHeroesViewController() as! SuperHeroesViewController
        superHeroesViewController.presenter = SuperHeroesPresenter(ui: superHeroesViewController,
                getSuperHeroes: GetSuperHeroes(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroesViewController]
        presentViewController(rootViewController)
        tester().waitForAnimationsToFinish()
    }
}