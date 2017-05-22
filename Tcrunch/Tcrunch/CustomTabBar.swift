
//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Adam Bardon on 07/03/16.
//  Copyright © 2016 Swift Joureny. All rights reserved.
//

import UIKit

protocol CustomTabBarDelegate {
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int)
}

class CustomTabBar: UITabBar {
    var cDelegate: CustomTabBarDelegate!
    
    var tabBarItems: [UITabBarItem]!
    var customTabBarItems: [CustomTabBarItem]!
    var tabBarButtons: [UIButton]!
    
    var initialTabBarItemIndex: Int!
    var selectedTabBarItemIndex: Int!
    var slideMaskDelay: Double!
    var slideAnimationDuration: Double!
    
    var tabBarItemWidth: CGFloat!
    var selectedMask: UIView!
    
    @IBInspectable var selectedColor : UIColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    @IBInspectable var backgroundColor2 : UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    @IBInspectable var iconColor : UIColor?
    @IBInspectable var selectedIconColor : UIColor?
    
    
    var tHeight: CGFloat?
    var itemHeight: CGFloat?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(startingIndex: Int) {
        
        tHeight = self.frame.height + self.frame.height * (1/4)
        itemHeight = self.frame.height * (1/4)
        
        //remove default from view
        for i in self.subviews {
            i.removeFromSuperview()
        }
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        
        // get tab bar items from default tab bar
        tabBarItems = items
        
        customTabBarItems = []
        tabBarButtons = []
        
        initialTabBarItemIndex = startingIndex
        selectedTabBarItemIndex = initialTabBarItemIndex
        
        slideAnimationDuration = 0.4
        slideMaskDelay = slideAnimationDuration / 2
        
        let containers = createTabBarItemContainers()
        
        createTabBarItemSelectionOverlay(containers: containers)
        createTabBarItemSelectionOverlayMask(containers: containers)
        createTabBarItems(containers: containers)
        
    }
    
    
    
    
    func createTabBarItemSelectionOverlay(containers: [CGRect]) {
        
        for index in 0..<tabBarItems.count {
            let container = containers[index]
            
            let view = UIView(frame: container)
            
            let selectedItemOverlay = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            selectedItemOverlay.backgroundColor = self.backgroundColor2
            view.addSubview(selectedItemOverlay)
            
            self.addSubview(view)
        }
    }
    
    func createTabBarItemSelectionOverlayMask(containers: [CGRect]) {
        
        tabBarItemWidth = self.frame.width / CGFloat(tabBarItems.count)
        
        selectedMask = UIView(frame: CGRect(x: CGFloat(initialTabBarItemIndex) * tabBarItemWidth, y: 0, width: tabBarItemWidth, height: self.frame.height))
        selectedMask.backgroundColor = selectedColor
        
        self.addSubview(selectedMask)
    }
    
    func createTabBarItems(containers: [CGRect]) {
        
        var index = 0
        for item in tabBarItems {
            
            let container = containers[index]
            
            let customTabBarItem = CustomTabBarItem(frame: container)
//            customTabBarItem.setup(item: item)
            
            self.addSubview(customTabBarItem)
            customTabBarItems.append(customTabBarItem)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: container.width, height: container.height))
            button.addTarget(self, action: #selector(CustomTabBar.barItemTapped), for: UIControlEvents.touchUpInside)
            
            customTabBarItem.addSubview(button)
            tabBarButtons.append(button)
            
            index += 1
        }
        
//        self.customTabBarItems[initialTabBarItemIndex].iconView.tintColor = UIColor.blue
        
    }
    
    func createTabBarItemContainers() -> [CGRect] {
        
        var containerArray = [CGRect]()
        
        // create container for each tab bar item
        for index in 0..<tabBarItems.count {
            let tabBarContainer = createTabBarContainer(index: index)
            containerArray.append(tabBarContainer)
        }
        
        return containerArray
    }
    
    func createTabBarContainer(index: Int) -> CGRect {
        
        let tabBarContainerWidth = self.frame.width / CGFloat(tabBarItems.count)
        let tabBarContainerRect = CGRect(x: tabBarContainerWidth * CGFloat(index), y: 0, width: tabBarContainerWidth, height: self.frame.height)
        
        return tabBarContainerRect
    }
    
    func animateTabBarSelection(from: Int, to: Int) {
        
        self.selectedMask.frame.origin.x = CGFloat(to) * self.tabBarItemWidth
        
        let iconFrom: CustomTabBarItem = customTabBarItems[from]
        let iconTo: CustomTabBarItem = customTabBarItems[to]
        
        if selectedIconColor != nil {
            iconTo.iconView.image = iconTo.iconView.image?.imageWithColor(newColor: selectedIconColor)
        }
        if iconColor != nil {
            iconFrom.iconView.image = iconFrom.iconView.image?.imageWithColor(newColor: iconColor)
        }
        
        //        UIView.animate(withDuration: slideAnimationDuration , delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
        //            self.selectedMask.frame.origin.x = CGFloat(to) * self.tabBarItemWidth
        //            }, completion: nil)
        
    }
    
    func barItemTapped(sender : UIButton) {
        let index = tabBarButtons.index(of: sender)!
        
        animateTabBarSelection(from: selectedTabBarItemIndex, to: index)
        selectedTabBarItemIndex = index
        cDelegate.didSelectViewController(tabBarView: self, atIndex: index)
    }
}
extension UIImage {
    
    convenience init?(imageName: String) {
        self.init(named: imageName)!
        accessibilityIdentifier = imageName
    }
    
    // http://stackoverflow.com/a/40177870/4488252
    func imageWithColor (newColor: UIColor?) -> UIImage? {
        
        if let newColor = newColor {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            
            newColor.setFill()
            context.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }
        
        if let accessibilityIdentifier = accessibilityIdentifier {
            return UIImage(imageName: accessibilityIdentifier)
        }
        
        return self
    }
}
