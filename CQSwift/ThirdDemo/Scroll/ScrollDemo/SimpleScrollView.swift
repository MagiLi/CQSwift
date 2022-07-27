//参考文章 https://blog.csdn.net/Px01Ih8/article/details/113749837

import UIKit

class SimpleScrollView: UIView {
    
    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let contentView = contentView {
                addSubview(contentView)
                contentView.frame = CGRect(origin: contentOrigin, size: contentSize)
            }
        }
    }
    
    var contentSize: CGSize = .zero {
        didSet {
            contentView?.frame.size = contentSize
        }
    }
    
    var contentOffset: CGPoint = .zero {
        didSet {
            contentView?.frame.origin = contentOrigin
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private

    private enum State {
        case `default` // 无事发生时
        case dragging(initialOffset: CGPoint) //滚动时
    }

    private var contentOrigin: CGPoint { return CGPoint(x: -contentOffset.x, y: -contentOffset.y) }
    
    private var contentOffsetBounds: CGRect {
        let width = contentSize.width - bounds.width
        let height = contentSize.height - bounds.height
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    private let panRecognizer = UIPanGestureRecognizer()
    private var lastPan: Date?
    
    private var state: State = .default
    
    private var contentOffsetAnimation: TimerAnimation?

    private func setup() {
        addGestureRecognizer(panRecognizer)
        panRecognizer.addTarget(self, action: #selector(handlePanRecognizer))
    }
    
    @objc private func handlePanRecognizer(_ sender: UIPanGestureRecognizer) {
        let newPan = Date()
        switch sender.state {
        case .began:
            stopOffsetAnimation()
            state = .dragging(initialOffset: contentOffset)
        
        case .changed:
            let translation = sender.translation(in: self)
            if case .dragging(let initialOffset) = state {
                contentOffset = clampOffset(initialOffset - translation)
            }
        
        case .ended:
            state = .default
            //当用户停止拖拽时平移手势识别器报告非零终端速度
            // Pan gesture recognizers report a non-zero terminal velocity even
            // when the user had stopped dragging:
            // https://stackoverflow.com/questions/19092375/how-to-determine-true-end-velocity-of-pan-gesture
            
            // In virtually all cases（在几乎所有情况下）, the pan recognizer seems to call this
            // handler at intervals of（间隔） less than（小于、少于） 100ms while the user is
            // dragging, so if this call occurs outside that window（因此如果此调用发生在该窗口之外）, we can
            // assume（假设） that the user had stopped, and finish scrolling without
            // deceleration.
            let userHadStoppedDragging = newPan.timeIntervalSince(lastPan ?? newPan) >= 0.1
            // 初速度
            let velocity: CGPoint = userHadStoppedDragging ? .zero : sender.velocity(in: self)
            print("velocity: \(velocity)")
            completeGesture(withVelocity: -velocity)
            
        case .cancelled, .failed:
            state = .default
            
        case .possible:
            break
        
        @unknown default:
            fatalError()
        }
        lastPan = newPan
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Freeze the scroll view at its current position so that the user can
        // interact with its content or scroll it.
        stopOffsetAnimation()
    }
    
    private func stopOffsetAnimation() {
        contentOffsetAnimation?.invalidate()
        contentOffsetAnimation = nil
    }
    
    private func startDeceleration(withVelocity velocity: CGPoint) {
        // 衰减率
        let d = UIScrollView.DecelerationRate.normal.rawValue // 0.998
        //let d = UIScrollView.DecelerationRate.fast.rawValue // 0.99
        // 衰减动画的参数
        // contentOffset：当前偏移量
        // velocity：减速时的初速度
        let parameters = DecelerationTimingParameters(initialValue: contentOffset, initialVelocity: velocity,
                                                      decelerationRate: d, threshold: 0.5)
        // 衰减滚动停止的点
        let destination = parameters.destination
        //  越界时的交点
        let intersection = getIntersection(rect: contentOffsetBounds, segment: (contentOffset, destination))
        
        let duration: TimeInterval
        
        if let intersection = intersection, let intersectionDuration = parameters.duration(to: intersection) {// 1.会越界
            // 越界之前的动画时间
            duration = intersectionDuration
        } else { // 2.不会越界
            // 衰减动画时间
            duration = parameters.duration
        }
        
        contentOffsetAnimation = TimerAnimation(
            duration: duration,
            animations: { [weak self] _, time in
                // 执行减速动画
                self?.contentOffset = parameters.value(at: time)
            },
            completion: { [weak self] finished in
                guard finished && intersection != nil else { return }
                // 减速动画执行到边界，执行弹性动画效果
                let velocity = parameters.velocity(at: duration)
                print("convertVelocity: \(velocity)")
                self?.bounce(withVelocity: velocity)
            })
    }
    
    private func bounce(withVelocity velocity: CGPoint) {
        let restOffset = contentOffset.clamped(to: contentOffsetBounds)
        let displacement = contentOffset - restOffset
        let threshold = 0.5 / UIScreen.main.scale
        let spring = Spring(mass: 1, stiffness: 100, dampingRatio: 1)
        
        let parameters = SpringTimingParameters(spring: spring,
                                                displacement: displacement,
                                                initialVelocity: velocity,
                                                threshold: threshold)
       
        contentOffsetAnimation = TimerAnimation(
            duration: parameters.duration,
            animations: { [weak self] _, time in
                self?.contentOffset = restOffset + parameters.value(at: time)
            })
    }

    // 夹紧偏移量（避免越界）
    private func clampOffset(_ offset: CGPoint) -> CGPoint {
        let rubberBand = RubberBand(dims: bounds.size, bounds: contentOffsetBounds)
        return rubberBand.clamp(offset)
    }
    
    private func completeGesture(withVelocity velocity: CGPoint) {
        if contentOffsetBounds.containsIncludingBorders(contentOffset) {
            startDeceleration(withVelocity: velocity)
        } else {
            bounce(withVelocity: velocity)
        }
    }
    
}
