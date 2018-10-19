//
//  DropDown.swift
//  MOAMC
//
//  Created by Ashish Vishwakarma on 13/03/18.
//  Copyright © 2018 Anurag Kulkarni. All rights reserved.
//

import UIKit

@objc protocol DropDownDelegate {
    @objc optional func dropDownOpened(dropDown: DropDown)
    @objc optional func dropDownClosed(dropDown: DropDown)
    func onSelectedIndexChanged(dropDown: DropDown, index: Int)
}

class DropDown: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownTitle: UILabel!
    @IBOutlet weak var dropDownImageView: UIImageView!
    var tableViewController: UITableViewController?
    
    static var openedDropDown: DropDown?
    var delegate: DropDownDelegate?
    
    var sourceData = [String]()
    static let DROPDOWNTAG = 10000
    var selectedIndex = -1
    var dropDownWidth: CGFloat?
    var marginBottom: CGFloat = 45
    
    var selectedItem : String {
        if selectedIndex >= sourceData.count {
            return ""
        }
        
        if selectedIndex < 0 {
            return ""
        }
        return sourceData[selectedIndex]
    }
    
    var iOpen: Bool {
        return dropDownView.tag == 1
    }
    
    static var dismissNotification: NSNotification.Name {
        return Notification.Name.init(rawValue: "resetDropDown")
    }
    
    @IBInspectable var defaultTitle: String = "Select" {
        didSet{
            dropDownTitle.text = defaultTitle
        }
    }
    
    @IBInspectable var dropDownBackground: UIColor = UIColor.white {
        didSet{
            dropDownView.backgroundColor = dropDownBackground
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    // Load DropDown View
    fileprivate func loadView() {
        
        Bundle.main.loadNibNamed("DropDown", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.cornerRadius = 2
        contentView.layer.borderWidth = 0.2
        contentView.addShadow()//dropShadow(color: .black, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 3, scale: true)
        
        dropDownTitle.text = defaultTitle
        dropDownImageView.tintColor = UIColor.black
        dropDownImageView.image = dropDownImageView.image?.withRenderingMode(.alwaysTemplate)
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropDownClick(sender:)))
        dropDownView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dropDownClick(sender: UITapGestureRecognizer) {
        //Do not open DropDown if there no element
        if sourceData.count < 1 {
            return
        }
        
        if DropDown.openedDropDown != self {
            DropDown.closeOpenedDropDownIfAny()
        }
        
        if dropDownView.tag == 0 {
            dropDownView.tag = 1
            DropDown.openedDropDown = self
            addDropDown()
        } else {
            DropDown.openedDropDown = nil
            closeDropDown()
        }
    }
    
    func setSelectedIndex(index: Int)
    {
        if index >= sourceData.count
        {
            return
        }
        
        if index < 0 {
            selectedIndex = -1
            dropDownTitle.text = defaultTitle
            return
        }
        
        selectedIndex = index
        dropDownTitle.text = sourceData[selectedIndex]
    }
    
    func closeDropDown() {
        if dropDownView.tag == 1 {
            UIView.animate(withDuration: 0.4, animations: {
                self.dropDownImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                self.tableViewController?.tableView.alpha = 0
                
            }, completion: {finished in
                self.dropDownView.tag = 0
                self.tableViewController?.tableView.removeFromSuperview()
                self.tableViewController = nil
            })
            if self.delegate?.dropDownClosed != nil {
                self.delegate?.dropDownClosed!(dropDown: self)
            }
            //Remove Observer
            NotificationCenter.default.removeObserver(self, name: DropDown.dismissNotification, object: nil)
        }
    }
    
    fileprivate func addDropDown()
    {
        guard sourceData.count > 0 else {
            return
        }
        
        tableViewController = UITableViewController()
        
        let globalPoint = superview?.convert(frame.origin, to: nil)

        let dropDownHeight:CGFloat = CGFloat((sourceData.count*40>160) ? 160 : sourceData.count*40)
        let xPos = globalPoint?.x
        var yPos = (globalPoint?.y)! + frame.height + 5
        
        let screenHeight = UIScreen.main.bounds.maxY
        if yPos+dropDownHeight+marginBottom > screenHeight {
            yPos = yPos-5-dropDownHeight
        }
        
        var dropDownWidth = dropDownView.frame.width
        if let width = self.dropDownWidth {
            dropDownWidth = width
        }
        
        tableViewController?.tableView.frame = CGRect(x: xPos!, y: yPos, width: dropDownWidth, height: CGFloat(dropDownHeight))
        tableViewController?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        tableViewController?.tableView.addShadow()
        tableViewController?.tableView.layer.borderWidth = 0.2
        tableViewController?.tableView.layer.borderColor = UIColor.white.cgColor
        tableViewController?.tableView.layer.cornerRadius = 2
        //tableViewController?.tableView.addShadow()
         tableViewController?.tableView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
        tableViewController?.tableView.tag = DropDown.DROPDOWNTAG
        tableViewController?.tableView.dataSource = self
        tableViewController?.tableView.delegate = self
        
        let visibleWindow = UIWindow.visibleWindow()
        visibleWindow?.addSubview((tableViewController?.tableView)!)
        visibleWindow?.bringSubview(toFront: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableViewController?.tableView.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.dropDownImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            self.tableViewController?.tableView.alpha = 1
        })
        
        if selectedIndex >= 0 && selectedIndex < sourceData.count {
            self.tableViewController?.tableView.scrollToRow(at: IndexPath(row: self.selectedIndex, section: 0), at: .top, animated: true)
        }
        
        if self.delegate?.dropDownOpened != nil {
            self.delegate?.dropDownOpened!(dropDown: self)
        }
        
        //Observer to reset DropDown
        NotificationCenter.default.addObserver(self, selector: #selector(resetDropDown), name: DropDown.dismissNotification, object: nil)
    }
    
    @objc func resetDropDown()
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.dropDownImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            self.tableViewController?.tableView.alpha = 0
            
        }, completion: {finished in
            self.dropDownView.tag = 0
            self.tableViewController?.tableView.removeFromSuperview()
            self.tableViewController = nil
        })
    }
    
    class func closeOpenedDropDownIfAny() {
        //Close any other DropDown if Opened
        if let openedDropDown = DropDown.openedDropDown {
            openedDropDown.dropDownImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            openedDropDown.tableViewController?.tableView.alpha = 0
            openedDropDown.dropDownView.tag = 0
            openedDropDown.tableViewController?.tableView.removeFromSuperview()
            openedDropDown.tableViewController = nil
            DropDown.openedDropDown = nil
        }
    }
}

//MARK: TABLEVIEW DATASOURCE AND DELEGATES
extension DropDown: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
        cell?.textLabel?.text = sourceData[indexPath.row]
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        cell?.textLabel?.font = cell?.textLabel?.font.withSize(12)
        
        if indexPath.row == selectedIndex {
            cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        } else {
            cell?.backgroundColor = UIColor.white
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex {
            self.dropDownView.tag = 0
            self.tableViewController?.tableView.removeFromSuperview()
            self.tableViewController = nil
            UIView.animate(withDuration: 0.4, animations: {
                self.dropDownImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                self.tableViewController?.tableView.alpha = 0
                
            })
            return
        }
        
        self.dropDownTitle.text = self.sourceData[indexPath.row]
        selectedIndex = indexPath.row
        UIView.animate(withDuration: 0.4, animations: {
            self.dropDownImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            self.tableViewController?.tableView.alpha = 0
            
        }, completion: {finished in
            self.dropDownView.tag = 0
            self.tableViewController?.tableView.removeFromSuperview()
            self.tableViewController = nil
            self.delegate?.onSelectedIndexChanged(dropDown: self, index: self.selectedIndex)
            if self.delegate?.dropDownClosed != nil {
                self.delegate?.dropDownClosed!(dropDown: self)
            }
        })
    }
}
