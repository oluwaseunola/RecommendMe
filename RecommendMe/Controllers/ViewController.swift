//
//  ViewController.swift
//  RecommendMe
//
//  Created by Seun Olalekan on 2021-09-01.
//
import SDWebImage
import UIKit
import SafariServices

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
  

    private let searchBar : UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "What are you craving?"
        bar.layer.cornerRadius = 7
        bar.backgroundImage = UIImage()
        
        
        
        return bar
    
    }()
    
    private let logoView : UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "logo")
        
        return view
    }()
    
    
    //MARK: - Lifecycle
    
    
    private var tableView : UITableView?
    private var mealResults : [Hit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOffView))
        gesture.delegate = self
        
        view.addGestureRecognizer(gesture)
        
        view.addSubview(searchBar)
        view.addSubview(logoView)
      
        
        searchBar.delegate = self
        view.backgroundColor = .systemBackground
        
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
         let size = view.width-20
        
        searchBar.frame = CGRect(x: mealResults.isEmpty ? (view.width - size)/2 : (view.width - size)/2 , y: mealResults.isEmpty ? (view.height-50)/2 : view.safeAreaInsets.bottom + 120, width: size , height: 50)
        
        logoView.frame = CGRect(x: mealResults.isEmpty ? (view.width-200)/2 : (view.width-100)/2, y: mealResults.isEmpty ? searchBar.top - 220 : view.safeAreaInsets.bottom + 10, width: mealResults.isEmpty ? 200 : 100, height: mealResults.isEmpty ? 200 : 100)
    
        
    }
    
    
    private func fetchData(){
      
        if let searchQuery = searchBar.text, !searchQuery.isEmpty {
            
            APIcall.getMeal(query: searchQuery) { model in
                
                switch model{
                    
                case.success(let model):
                   
                    
                        self.mealResults = model.hits
                        self.configureTableView()
                    
                
                    
                case.failure(let error):
                    break
                }
                
            
            }
        } else{
            
            let alert = UIAlertController(title: "Error", message: "Please enter a food", preferredStyle: .alert)
            
            let close = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(close)
            
            present(alert, animated: true, completion: nil)
            
        }
        
       

        
    }
    
    //MARK: - Button Functions
    
    @objc func didTapOffView(){
        
        searchBar.resignFirstResponder()
        
    }
    
    
    
    

    //MARK: - Configure TableView
    
    private func configureTableView(){
        DispatchQueue.main.async {
            let table = UITableView()
            

            table.delegate = self
            table.dataSource = self
            table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableView = table
        

            self.view.addSubview(self.tableView ?? UITableView())

            self.tableView?.reloadData()
            
            self.tableView?.frame = CGRect(x: 0, y: self.mealResults.isEmpty ? 0 : 250, width: self.view.width, height: self.view.height - self.searchBar.height - 260)
    
        }
       
       
        
    }
    
    //MARK: - Delegate Functions
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let meal = mealResults[indexPath.row]
        
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator

        
        DispatchQueue.main.async {
            
            cell.textLabel?.text = meal.recipe.label
            
            guard let url = URL(string: meal.recipe.image) else {return}
            
            cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"), completed: nil)
            
        
        }
        
        
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let meal = mealResults[indexPath.row]
        
        guard let url = URL(string:meal.recipe.shareAs) else {return}
        
        let link = SFSafariViewController(url: url)
        
        present(link, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchData()
            
    }
    
    
    

}

extension ViewController : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView ?? UITableView()) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
}

}
