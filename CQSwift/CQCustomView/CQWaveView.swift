//
//  CQWaveView.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/28.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

class CQWaveView: UIView {
    open var waveCurvature: CGFloat = 1.5 // wave curvature
    open var waveSpeed: CGFloat = 1 // wave speed
    open var waveHeight: CGFloat = 5 // wave height
    
    open var realWaveColor: UIColor = UIColor.red {// real wave color
        didSet {
            self.realWaveLayer.fillColor = self.realWaveColor.cgColor
        }
    }
    open var maskWaveColor: UIColor = UIColor.red {// mask wave color
        didSet {
            self.maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        }
    }
    
    open var overView: UIView? // float over View
    fileprivate var timer: CADisplayLink?// wave timmer
    fileprivate var realWaveLayer :CAShapeLayer = CAShapeLayer()// real wave
    fileprivate var maskWaveLayer :CAShapeLayer = CAShapeLayer()// mask wave
    fileprivate var offset :CGFloat = 0
    
    fileprivate var _waveCurvature: CGFloat = 0
    fileprivate var _waveSpeed: CGFloat = 0
    fileprivate var _waveHeight: CGFloat = 0
    fileprivate var _starting: Bool = false
    fileprivate var _stoping: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layerFrame = CGRect(x: 0.0, y: frame.size.height, width: frame.size.width, height: 0.0)
        maskWaveLayer.frame = layerFrame
        realWaveLayer.frame = layerFrame
    }
    
    /**
     Init view with wave color

     - parameter frame: view frame
     - parameter color: real wave color

     - returns: view
     */
    public convenience init(frame: CGRect, color:UIColor, image:UIImage?) {
        self.init(frame: frame)
        self.realWaveColor = color
        self.maskWaveColor = color.withAlphaComponent(0.4)
        
        realWaveLayer.fillColor = self.realWaveColor.cgColor
        maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        
        self.layer.addSublayer(self.realWaveLayer)
        self.layer.addSublayer(self.maskWaveLayer)
        
//        let overView = UIView(frame: frame)
//        overView.backgroundColor = UIColor.orange
//        self.addOverView(overView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func addOverView(_ view: UIView) {
        overView = view
        overView?.center = self.center
        overView?.frame.origin.y = self.frame.height - (overView?.frame.height)!
        self.addSubview(overView!)
    }
    
    /**
     Start wave
     */
    open func start() {
        if !_starting {
            _stop()
            _starting = true
            _stoping = false
            _waveHeight = 4.85
            _waveCurvature = 1.38
            _waveSpeed = 0.9
            
            timer = CADisplayLink(target: self, selector: #selector(wave))
            timer?.add(to: RunLoop.current, forMode: RunLoop.Mode.commonModes)
        }
    }
    
    /**
     Stop wave
     */
    open func _stop(){
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    open func stop(){
        if !_stoping {
            _starting = false
            _stoping = true
        }
    }
    
    /**
     Wave animation
     */
    @objc func wave() {
        
        if _starting {
            if _waveHeight < waveHeight {
                _waveHeight = _waveHeight + waveHeight/100.0
                var frame = self.bounds
                frame.origin.y = frame.size.height-_waveHeight
                frame.size.height = _waveHeight
                maskWaveLayer.frame = frame
                realWaveLayer.frame = frame
                _waveCurvature = _waveCurvature + waveCurvature / 100.0
                _waveSpeed = _waveSpeed + waveSpeed / 100.0
            } else {
                _starting = false
            }
        }
        
        if _stoping {
            if _waveHeight > 0 {
                _waveHeight = _waveHeight - waveHeight/50.0
                var frame = self.bounds
                frame.origin.y = frame.size.height
                frame.size.height = _waveHeight
                maskWaveLayer.frame = frame
                realWaveLayer.frame = frame
                _waveCurvature = _waveCurvature - waveCurvature / 50.0
                _waveSpeed = _waveSpeed - waveSpeed / 50.0
            } else {
                _stoping = false
                _stop()
            }
        }
        
        offset += _waveSpeed
        
        let width = frame.width
        let height = CGFloat(_waveHeight)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height))
        var y: CGFloat = 0
        
        let maskpath = CGMutablePath()
        maskpath.move(to: CGPoint(x: 0, y: height))
        
        let offset_f = Float(offset * 0.045)
        let waveCurvature_f = Float(0.01 * _waveCurvature)
        
        for x in 0...Int(width) {
            y = height * CGFloat(sinf( waveCurvature_f * Float(x) + offset_f))
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            maskpath.addLine(to: CGPoint(x: CGFloat(x), y: -y))
        }
        
        if (overView != nil) {
            let centX = self.bounds.size.width/2
            let centY = height * CGFloat(sinf(waveCurvature_f * Float(centX)  + offset_f))
            let center = CGPoint(x: centX , y: centY + self.bounds.size.height - overView!.bounds.size.height/2 - _waveHeight - 1 )
            overView?.center = center
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        path.closeSubpath()
        self.realWaveLayer.path = path
        
        maskpath.addLine(to: CGPoint(x: width, y: height))
        maskpath.addLine(to: CGPoint(x: 0, y: height))
        
        maskpath.closeSubpath()
        self.maskWaveLayer.path = maskpath
        
    }
    
    
}
