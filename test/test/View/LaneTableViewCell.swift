import UIKit

class LaneTableViewCell: UITableViewCell {
    
    static let identifier = "LaneTableViewCell"
    
    private var wordBoxes: [WordBox] = []
    private var activeIndex: Int = 0  // Active word is the one at this index.
    private var lane: Int = 0
    private var words: [String] = []
    private var boxSize: CGSize = .zero
    private var verticalGap: CGFloat = 0
    
    /// Closure that is called when a word is captured.
    var onCapture: ((String) -> Void)?
    
    /// Configures the cell with the lane’s unique words.
    /// - Parameters:
    ///   - words: The unique words for this lane.
    ///   - lane: The lane index.
    ///   - boxSize: The size to use for each word box.
    ///   - verticalGap: The vertical gap between boxes.
    func configure(with words: [String], lane: Int, boxSize: CGSize, verticalGap: CGFloat) {
        self.lane = lane
        self.words = words
        self.boxSize = boxSize
        self.verticalGap = verticalGap
        activeIndex = 0
        // Remove any old word boxes.
        for box in wordBoxes { box.removeFromSuperview() }
        wordBoxes.removeAll()
        
        // Create WordBox views for each word in the lane.
        let totalHeight = CGFloat(words.count) * boxSize.height + CGFloat(words.count + 1) * verticalGap
        let startY = verticalGap
        for word in words {
            let speed = CGFloat.random(in: 1...3)
            let box = WordBox(text: word, speed: speed, lane: lane, initialX: 0)
            // Initially, all waiting words are positioned at x = 0.
            box.frame = CGRect(origin: CGPoint(x: 0, y: startY), size: boxSize)
            box.state = .set
            // Add tap gesture recognizer.
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(wordTapped(_:)))
            box.addGestureRecognizer(tapGesture)
            box.isUserInteractionEnabled = true
            contentView.addSubview(box)
            wordBoxes.append(box)
        }
        // Position the word boxes vertically.
        repositionWords()
    }
    
    /// Repositions waiting word boxes so they are stacked vertically starting at x = 0.
    private func repositionWords() {
        let count = wordBoxes.count
        let startY = verticalGap
        for (i, box) in wordBoxes.enumerated() {
            let y = startY + CGFloat(i) * (boxSize.height + verticalGap)
            box.frame = CGRect(origin: CGPoint(x: 0, y: y), size: boxSize)
        }
    }
    
    /// Called when a word box is tapped.
    /// Only the active (top) word (at activeIndex) is tappable.
    @objc private func wordTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedBox = gesture.view as? WordBox else { return }
        // Ensure the tapped box is the active word.
        if activeIndex < wordBoxes.count, wordBoxes[activeIndex] === tappedBox, tappedBox.state == .moving {
            tappedBox.state = .captured
            onCapture?(tappedBox.text ?? "")
            tappedBox.removeFromSuperview()
            wordBoxes.remove(at: activeIndex)
            activeIndex = 0 // Next waiting word becomes active.
            repositionWords()
        }
    }
    
    /// Updates the active word’s horizontal position.
    /// The active word is the one at index activeIndex.
    /// - Parameter width: The available width (the game area’s width).
    func updateActiveWord(in width: CGFloat) {
        guard activeIndex < wordBoxes.count else { return }
        let activeBox = wordBoxes[activeIndex]
        if activeBox.state == .set {
            activeBox.state = .moving
        }
        var frame = activeBox.frame
        frame.origin.x += activeBox.speed
        activeBox.frame = frame
        // Define the finish line so that the word "sticks" on the right.
        let finishX = width - boxSize.width
        if activeBox.frame.origin.x >= finishX {
            activeBox.frame.origin.x = finishX
            activeBox.state = .finished  // Word is finished (blue) and untappable.
            activeIndex += 1  // Advance to the next word in this lane.
            repositionWords()
        }
    }
}
