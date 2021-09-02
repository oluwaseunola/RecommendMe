//
//  API Call.swift
//  RecommendMe
//
//  Created by Seun Olalekan on 2021-09-01.
//

import Foundation

struct APIcall{
   
    static func getMeal(query: String, completion: @escaping (Result<MealModel,Error>)-> Void){
       
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=\(query)&app_id=a128e464&app_key=595aa56903851c2660921e42f7ff019f") else {return}
        
        let session = URLSession.shared.dataTask(with: url) { result, _, error in
            guard let result = result else {
                return
            }



            do{
                guard let data = try? JSONDecoder().decode(MealModel.self, from: result) else{return}
                
                completion(.success(data))
                
            }
            catch{
                print(error.localizedDescription)
            }
            
            if let resultError = error {
                completion(.failure(resultError))
            }
            
            
        }
        session.resume()
        
    }
    

    

    
}
