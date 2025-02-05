import UIKit

/// A view that contains multiple LaneViews, arranged vertically.
final class GameAreaView: UIView {
    private var vm: GameAreaViewModel
    private var laneViews: [LaneView] = []
    
    /// Called when a word is captured in any lane
    var onCapturedWord: ((String) -> Void)?
    
    init(frame: CGRect, viewModel: GameAreaViewModel) {
        self.vm = viewModel
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupLaneViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLaneViews() {
        laneViews.forEach { $0.removeFromSuperview() }
        laneViews.removeAll()
        
        let laneCount = vm.laneViewModels.count
        guard laneCount > 0 else { return }
        
        let laneHeight = bounds.height / CGFloat(laneCount)
        for (i, laneVM) in vm.laneViewModels.enumerated() {
            let laneY = CGFloat(i) * laneHeight
            let lane = LaneView(
                frame: CGRect(x: 0, y: laneY, width: bounds.width, height: laneHeight),
                viewModel: laneVM
            )
            lane.onCapturedWord = { [weak self] word in
                self?.onCapturedWord?(word)
            }
            addSubview(lane)
            laneViews.append(lane)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Re-layout the lane frames if size changes (e.g. rotation)
        let laneCount = laneViews.count
        let laneHeight = laneCount > 0 ? bounds.height / CGFloat(laneCount) : 0
        for (i, lane) in laneViews.enumerated() {
            lane.frame = CGRect(
                x: 0,
                y: CGFloat(i) * laneHeight,
                width: bounds.width,
                height: laneHeight
            )
        }
    }
}
