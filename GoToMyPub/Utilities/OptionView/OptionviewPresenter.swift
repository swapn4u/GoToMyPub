//
//  OptionviewPresenter.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 29/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

protocol selectionOptionProtocol {
    func selectedItems(items:[String])
}

class OptionviewPresenter: UIViewController {
    //outlet collections
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var dropDownTitle: UILabel!
    @IBOutlet weak var searchHolderViewConstraint: NSLayoutConstraint!
    
    // varibles and constantys
    var optionElementsArr = [String](){didSet{optionElementsArr=optionElementsArr.sorted()}}
    var dropdownTitleStr = ""
    var previousSelectedItems = [String](){didSet{previousSelectedItems=previousSelectedItems.sorted()}}
    var isSearchBarOpen = false
    var selectedIndex = [Int](){didSet{tabelView.reloadData()}}
    var filterSelectedIndex = [Int](){didSet{tabelView.reloadData()}}
    var filteredArr = [String]()
    var isFilterActive = false
    
    //delegation protocol
    var selectedOptiondelegate : selectionOptionProtocol?
    
    //view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownTitle.text = dropdownTitleStr
        
        selectedIndex.removeAll()
        for item in previousSelectedItems
        {
              let indexOfSelectedItam =  optionElementsArr.index(of: item)
              selectedIndex.append(indexOfSelectedItam!)
            self.searchView.layoutIfNeeded()
            self.searchView.updateConstraintsIfNeeded()
        }

    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.5) {
            self.searchHolderViewConstraint.constant = self.isSearchBarOpen ? 0 : 44
        }
        _ = isSearchBarOpen ? searchBar.becomeFirstResponder() : searchBar.resignFirstResponder()
        isSearchBarOpen = !isSearchBarOpen
    }
    @IBAction func DoneButtonPressed(_ sender: UIButton)
    {
        var resultedArr = [String]()
        if selectedIndex.count>0
        {
        for item in selectedIndex
        {
            resultedArr.append(optionElementsArr[item])
        }
        }
     self.selectedOptiondelegate?.selectedItems(items: resultedArr)
        self.dismiss(animated: false)
    }
    
}
extension OptionviewPresenter:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilterActive ? filteredArr.count : optionElementsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = isFilterActive ? filteredArr[indexPath.row] : optionElementsArr[indexPath.row]
        let checkmarkArr = isFilterActive ? filterSelectedIndex : selectedIndex
        if checkmarkArr.contains(indexPath.row)
        {
            cell?.accessoryType = .checkmark
        }
        else
        {
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFilterActive
        {
            let cell = tableView.cellForRow(at: indexPath)
            let name = cell?.textLabel?.text!
            let index = optionElementsArr.index(of: name!)!
            
            if filterSelectedIndex.contains(indexPath.row)
            {
                let x = filterSelectedIndex.index(of: indexPath.row)
                filterSelectedIndex.remove(at:x!)
            }
            else
            {
                filterSelectedIndex.append(indexPath.row)
            }
            
            
            if selectedIndex.contains(index)
            {
                let x = selectedIndex.index(of: index)
                selectedIndex.remove(at:x!)
            }
            else
            {
                selectedIndex.append(index)
            }
        }
        else
        {
            if selectedIndex.contains(indexPath.row)
            {
                let x = selectedIndex.index(of: indexPath.row)
                selectedIndex.remove(at:x!)
            }
            else
            {
                selectedIndex.append(indexPath.row)
            }
        }
        tabelView.reloadData()
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
//searchBar
extension OptionviewPresenter : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        filterSelectedIndex.removeAll()
        isFilterActive = searchText.count>0 ? true : false
        
        filteredArr = optionElementsArr.filter{$0.lowercased().contains(searchText.lowercased())}.sorted()
        tabelView.reloadData()
        print(filteredArr)
    }
    
}

