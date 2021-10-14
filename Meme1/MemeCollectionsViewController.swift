//
//  MemeCollectionsViewController.swift
//  Meme1
//
//  Created by Malrasheed on 05/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var memes = [Meme]()
    enum storyBoardIDS: String {
        case MemeCollectionViewCell = "MemeCollectionViewCell"
        case MemeDetailViewController = "MemeDetailViewController"
        case CreateMemeViewController = "CreateMemeViewController"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.collectionView.reloadData()
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyBoardIDS.MemeCollectionViewCell.rawValue , for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.MemeImage?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: storyBoardIDS.MemeDetailViewController.rawValue) as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    @IBAction func createMeme(_ sender: Any) {
        let createMeme = self.storyboard!.instantiateViewController(withIdentifier: storyBoardIDS.CreateMemeViewController.rawValue) as! CreateMemeViewController
        createMeme.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(createMeme, animated: true)
    }
}
