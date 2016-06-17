//
//  ViewController.swift
//  SlideshowApp
//
//  Created by 宮崎英美 on 2016/06/16.
//  Copyright © 2016年 taro.kirameki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playstopButton: UIButton!
    @IBOutlet weak var nextImage: UIButton!
    @IBOutlet weak var backImage: UIButton!
    var imageName:String = "cat"
    var number:Int = 1
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //デフォルトの表示画像を設定
        let image = UIImage(named: "\(imageName)" + number.description + ".jpg")!
        imageView.image = image
        
        //ImageViewのタップイベントを設定
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTap(_:)))
        self.imageView.addGestureRecognizer(tapGesture)
        
        //各ボタンのタップイベントを設定
        playstopButton.addTarget(self, action: #selector(ViewController.buttonTap), forControlEvents: .TouchUpInside)
        nextImage.addTarget(self, action: #selector(ViewController.buttonTap), forControlEvents: .TouchUpInside)
        backImage.addTarget(self, action: #selector(ViewController.buttonTap), forControlEvents: .TouchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //timerの設定
    func timerInit() {
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ViewController.imageChange as (ViewController) -> () -> ()), userInfo: nil, repeats: true)
    }
    //timerの開始
    func timerStart(sender : UIImageView){
        if(!timer.valid){
            timerInit()
        }
    }
    //timerの停止
    func timerStop(){
        timer?.invalidate()
    }
    
    //ボタンタップ時の動作
    func buttonTap(sender:UIButton){
        switch sender.tag {
        case 1:
            if sender.titleLabel?.text == "再生" {
                timerInit()
                sender.setTitle("停止", forState: UIControlState.Normal)
                nextImage.enabled = false
                backImage.enabled = false
            }else if sender.titleLabel?.text == "停止" {
                timerStop()
                sender.setTitle("再生", forState: UIControlState.Normal)
                nextImage.enabled = true
                backImage.enabled = true
            }
        case 2:
            imageChange(1)
        case 3:
            imageChange(-1)
        default:
            break
        }
    }
    
    //画像タップ時の動作
    func imageTap(sender:UITapGestureRecognizer){
        //再生時タイマーを停止するために再生/停止ボタンのタップイベントを呼び出す
        if playstopButton.titleLabel?.text == "停止" {
            buttonTap(playstopButton)
        }
        // ResultViewControllerへ遷移するためのSegueを呼び出す
        performSegueWithIdentifier("toResultViewController",sender: nil)
    }
    
    //画像切り替え（timerからの呼び出し）
    func imageChange(){
        imageChange(1)
    }
    //画像切り替え
    func imageChange(count:Int){
        number = number + count
        if number > 6 {
            number = 1
        }else if number < 1 {
            number = 6
        }
        let image = UIImage(named: "\(imageName)" + number.description + ".jpg")!
        imageView.image = image
    }
    
    //segueの設定
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let resultViewContlloer:ResultViewController = segue.destinationViewController as!ResultViewController
        resultViewContlloer.imangeName = "\(imageName)" + number.description + ".jpg"
        
    }
    
    // 他画面からの戻り
    @IBAction func unwind(segue:UIStoryboardSegue){
    }

}

