//
//  MealModel.swift
//  RecommendMe
//
//  Created by Seun Olalekan on 2021-09-01.
//

import Foundation

struct MealModel: Codable{
    
    let hits : [Hit]
    

}

struct Hit: Codable{
    let recipe : Recipe
}

struct Recipe: Codable {
    
    let label : String
    let image : String
    let shareAs: String
}
