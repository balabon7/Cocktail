//
//  DrinksAPI.swift
//  CocktailDB
//
//  Created by mac on 22.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//


import Foundation
import Alamofire

struct NetworkingClient {
    
    private let listUrl = "https://www.thecocktaildb.com/api/json/v1/1/list.php?"
    private let filterUrl = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?"
    
    let listParameters: [String : Any]  = ["c": "list"]
    
    typealias ServiceResponse = (Data?) -> Void
    
    func getCategory(category: String, complition: @escaping ServiceResponse) {
        
        let categoriesParameters  = ["c": category]
        AF.request(filterUrl, method: .get, parameters: categoriesParameters).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                complition(response.data)
                
            case .failure(let error):
                if response.response?.statusCode == 200 {
                    complition(nil)
                } else {
                    print(error)
                }
            }
            
            
        }
        
    }
    
    func getList(complition: @escaping ServiceResponse ) {
        
        AF.request(listUrl, method: .get, parameters: listParameters).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                complition(response.data)
            case .failure(let error):
                if response.response?.statusCode == 200 {
                    complition(nil)
                } else {
                    print(error)
                }
            }
        }
        
    }
}
