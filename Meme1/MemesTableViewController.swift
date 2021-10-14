//
//  SentMemesTableViewController.swift
//  Meme1
//
//  Created by Malrasheed on 31/10/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
class MemesTableViewController: UITableViewController {
    
    var memes = [Meme]()
    
    enum storyBoardIDS: String {
        case MemeCell = "MemeCell"
        case MemeDetailViewController = "MemeDetailViewController"
        case CreateMemeViewController = "CreateMemeViewController"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyBoardIDS.MemeCell.rawValue)!
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = meme.topText + "..." + meme.buttomText
        cell.imageView?.image = meme.memedImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

