//
//  SettingsLauncher.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 8/26/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
        var settings: [String] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    } ()
    
    let showSpeed = 0.3
    let cellId: String = "settingCell"
    var cellHeight: CGFloat = 40
    var delegate: SettingsLauncherDelegate?
    var parent: UIViewController?
    var view: UIView?
    
    init(settings: [String]) {
        super.init()
        
        self.settings = settings
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOptionDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            
            let width:CGFloat = window.frame.width * (1/2)
            
            collectionView.frame = CGRect(x: window.frame.width, y: -height, width: width, height: height)
            collectionView.alpha = 1
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: showSpeed, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: window.frame.width - self.collectionView.frame.width - 5, y: 25, width: width, height: height)
            }, completion: nil)
            
        }
    }
    
    func handleOptionDismiss() {
        UIView.animate(withDuration: showSpeed, animations: {
            self.blackView.alpha = 0
            self.collectionView.alpha = 0
        }, completion: {
            (done)in
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: window.frame.width, y: -self.collectionView.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        cell.nameLabel.text = settings[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.settingsLauncher(SettingsSelected: settings[indexPath.row])
        handleOptionDismiss()
    }
    
}

protocol SettingsLauncherDelegate {
    func settingsLauncher(SettingsSelected selected: String)
}
