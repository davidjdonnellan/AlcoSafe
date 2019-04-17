//
//  TimerViewController.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 04/10/2018.
//  Copyright © 2018 CS_UCC. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var BACLabel: UILabel!
    @IBOutlet weak var BackGroundImage: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    var buttonClicked:Bool!
    var recvTime:String? = ""
    var recvBAC:Double? = 0.0
    var timeSeconds:Int? = 0
    var timer = Timer()
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let trackLayer1 = CAShapeLayer()
    let percentageLayer: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = UIColor.white
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TimeHere: ",recvTime!)
        // shows time passed from modelTesT VC
        //the following code sets up how to timer is displayed
        // the need for multiple layes is to display the timer as a circle on the view
       BackGroundImage.layer.zPosition = -1; view.addSubview(percentageLayer)
        percentageLayer.frame = CGRect(x: 0, y: 0, width: 125, height:125 )
        percentageLayer.center = view.center
        percentageLayer.layer.zPosition = 3;
        // TRACK LAYER UNDERNEATH CIRCLE shows the path the animation will take
        let trackPath = UIBezierPath(arcCenter: .zero, radius: 105, startAngle:0, endAngle: 2  * CGFloat.pi, clockwise: true)
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.borderColor = UIColor.gray.cgColor
        trackLayer.lineWidth = 15
        trackLayer.strokeEnd = 0
        trackLayer.fillColor = UIColor.gray.cgColor
        trackLayer.position = view.center
        trackLayer.zPosition = 2
        view.layer.addSublayer(trackLayer)
        
        let InnerPath = UIBezierPath(arcCenter: .zero, radius: 95, startAngle:0, endAngle: 2  * CGFloat.pi, clockwise: true)
        trackLayer1.path = InnerPath.cgPath
        trackLayer1.strokeColor = UIColor.black.cgColor
        trackLayer1.borderColor = UIColor.black.cgColor
        trackLayer1.lineWidth = 15
        trackLayer1.strokeEnd = 0
        trackLayer1.fillColor = UIColor.black.cgColor
        trackLayer1.position = view.center
        trackLayer1.zPosition = 2
        view.layer.addSublayer(trackLayer1)
         //defines circle
        
        
        // CIRCLE ANIMATION
        let circlePath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle:0, endAngle: 2  * CGFloat.pi, clockwise: true) //defines circle
        shapeLayer.path = circlePath.cgPath
        //shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round // makes the outer circle tip rounder
        shapeLayer.fillColor = UIColor.clear.cgColor     // removes the center colour of cirlce
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1) //makes the start position of circle appear at 12 o'clock on animation rather thatn starting at 3
        shapeLayer.zPosition = 4
        view.layer.addSublayer(shapeLayer)

        if buttonClicked == true && (recvTime! as NSString).integerValue >  0{
            buttonClicked = false
            startTimer()
        }
        
    }
    // animates circle
    fileprivate func  animateCircle() {
        let firstAnimation = CABasicAnimation(keyPath: "strokeEnd")
        firstAnimation.toValue = 1
        firstAnimation.duration = CFTimeInterval(timeSeconds!) // change this to get a slower circle animation seconds
        firstAnimation.fillMode = CAMediaTimingFillMode.forwards //need this line for animation to stay at the end
        firstAnimation.isRemovedOnCompletion = false
        shapeLayer.add(firstAnimation,forKey: "firstAnimation")

    }
    // runs timer and starts timer process - called eachtime button is pressed
    func runTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(changeLabel)), userInfo: nil, repeats: true)
    }
    
    // changes the label every second  - displays how many hrs mins and scnds are displayed
    @objc func changeLabel(){
        var hrs = 0
        var mins = 0
        var scnds = 0
        var timeString = ""
        if timeSeconds != 0 {
            timeSeconds = timeSeconds! - 1
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: timeSeconds!)
            hrs = h
            mins = m
            scnds = s
            timeString = "\(hrs):\(mins):\(scnds)"
            percentageLayer.text = timeString
        }
            
        else{
            timer.invalidate()
        }
    }
    //override func viewDidAppear(_ animated: Bool) {
    func startTimer(){
        timeSeconds = (recvTime! as NSString).integerValue
        animateCircle()
        runTimer()
    }
    
    // need this function with if so when user clicks out of tab the timer stays running
    // function also displays info to the user related to how much they have drank and telling user they are under the legal limit
    override func viewDidAppear(_ animated: Bool) {
        let tmptime = (recvTime! as NSString).integerValue
        if buttonClicked == true && tmptime > 0 {
            buttonClicked = false
            BACLabel.text = String(format: "%.4f", recvBAC! as Double)
            startTimer()
        }
        
        if recvBAC! == 0.0{
            costLabel.text = "No Data Entered."
        }
        else if recvBAC! <= 0.02{
            costLabel.text = "You are under Limit to Drive"
            shapeLayer.strokeColor = UIColor.green.cgColor
            costLabel.textColor = UIColor.green
        }
        
        else if recvBAC! > 0.02 && recvBAC! <= 0.1{
             BACLabel.textColor = UIColor.orange
             shapeLayer.strokeColor = UIColor.orange.cgColor
             costLabel.text = "Over Legal Driving Limit"
            costLabel.textColor = UIColor.orange
        }
        else if recvBAC! > 0.1 && recvBAC! <= 0.2{
            BACLabel.textColor = UIColor.orange
             shapeLayer.strokeColor = UIColor.orange.cgColor
             costLabel.text = "Over Legal Driving Limit. Reduce consumption."
             costLabel.textColor = UIColor.orange
        }
        else if  recvBAC! > 0.2 && recvBAC! <= 0.3{
          BACLabel.textColor = UIColor.orange
            shapeLayer.strokeColor = UIColor.orange.cgColor
            costLabel.text = "Over Legal Driving Limit. Do not intake anymore alcohol"
             costLabel.textColor = UIColor.orange
            
        }
        else{
         BACLabel.textColor = UIColor.red
         shapeLayer.strokeColor = UIColor.red.cgColor
          costLabel.text = "Severely Over Recommended Alcohol Intake. DO NOT DRIVE"
             costLabel.textColor = UIColor.red
        }
    }
    
    
    // converting time in seconds to hrs mins seconds - simple function that converst seconds to hrs mins and secs
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}
