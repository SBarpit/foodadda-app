//
//  ViewController.swift
//  PickerView + API
//
//  Created by Appinventiv Mac on 15/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var searchBox: UISearchBar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headingLB: UILabel!
    
    var network:Network!
    var data:[String] = ["Chines Food in Noida","South Indian Food in Noida","North Indian Food in Noida","Non-Veg Food in Noida","Veg Food in Noida","Italian Food in Noida","Pizza in Noida"]
    var images:[String] = ["1","2","3","4","5","6","7","8","9","10","11"]
    var toggle = false
    override func viewDidLoad() {
        super.viewDidLoad()
        network = Network()
        network.vc = self
        headerView.layer.shadowColor = UIColor.orange.cgColor
        headerView.layer.shadowOffset = CGSize(width: 8, height: 8)
        headerView.layer.shadowOpacity = 0.8
        headerView.layer.masksToBounds = false
        
        headingLB.layer.shadowColor = UIColor.yellow.cgColor
        headingLB.layer.shadowOffset = CGSize(width: 2, height: 2)
        headingLB.layer.shadowOpacity = 0.8
        headingLB.layer.masksToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBox.resignFirstResponder()
    }


}


extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell
        cell?.imageView.image = UIImage(named: images[indexPath.item])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width - 5, height: collectionView.bounds.height)
        
    }
    

}


extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return network.rating.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath) as? TVCell
        cell?.myImageView?.downloadedFrom(link: network.imageURLS[indexPath.row])
        cell?.nameLB.text = network.name[indexPath.row]
        if network.rating.count < indexPath.row - 1{
              cell?.ratingLB.text = "No ratings"
        }else{
        cell?.ratingLB.text = "\(network.rating[indexPath.row]) ⭐"
        }
        cell?.addLB.text = network.address[indexPath.row]
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapvc = self.storyboard?.instantiateViewController(withIdentifier: "mv") as? MapView
        self.navigationController?.pushViewController(mapvc!, animated: true)
    }
}


extension ViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchBox.text = data[row]
        pickerView.isHidden = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBox.text!)
        var query = self.searchBox.text
        query = query?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        network.getResponce(query!)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !toggle{
           pickerView.isHidden = false
            toggle = !toggle
        }else{
        pickerView.isHidden = true
        toggle = !toggle
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
              self.tableView.reloadData()
            })
        }
        
}
    
}

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

