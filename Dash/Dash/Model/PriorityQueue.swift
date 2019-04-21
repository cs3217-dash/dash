// Copyright (c) 2018 NUS CS3217. All rights reserved.

/**
 The `PriorityQueue` accepts and maintains the elements in an order specified by
 their priority. For example, a Minimum Priority Queue of integers will serve
 (poll) the smallest integer first.

 Elements with the same priority are allowed, and such elements may be served in
 any order arbitrarily.

 `PriorityQueue` is a generic type with a type parameter `T` that has to be
 `Equatable` so that `T` can be compared.

 - Authors: CS3217
 - Date: 2018
 */
struct PriorityQueue {

    private var array = [MovingObject]()
    private let min: Bool

    /// Creates either a Min or Max `PriorityQueue`. Defaults to `min = true`.
    /// - Parameter min: Whether to return smallest elements first.
    init(min: Bool = true) {
        self.min = min
    }

    /// Adds the element.
    mutating func add(_ item: MovingObject) {
        array.append(item)
        bubbleUp(elementAtIndex: count - 1)
    }

    /// Returns the currently highest priority element.
    /// - Returns: the element if not nil
    func peek() -> MovingObject? {
        return array.first
    }

    /// Removes and returns the highest priority element.
    /// - Returns: the element if not nil
    mutating func poll() -> MovingObject? {
        guard !isEmpty else {
            return nil
        }
        array.swapAt(0, count - 1)
        let highestPriorityElement = array.removeLast()
        if !isEmpty {
            bubbleDown(elementAtIndex: 0)
        }
        return highestPriorityElement
    }

    /// The number of elements in the `PriorityQueue`.
    var count: Int {
        return array.count
    }

    /// Whether the `PriorityQueue` is empty.
    var isEmpty: Bool {
        return array.isEmpty
    }

    private func getParentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    private func getLeftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }

    private func getRightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }

    private mutating func bubbleUp(elementAtIndex index: Int) {
        guard index > 0, index < count else {
            return
        }

        let parentIndex = getParentIndex(of: index)

        if isHigherPriority(at: index, than: parentIndex) {
            array.swapAt(index, parentIndex)
            bubbleUp(elementAtIndex: parentIndex)
        }
    }

    private mutating func bubbleDown(elementAtIndex index: Int) {
        guard index >= 0, index < count else {
            return
        }

        guard let childIndex = getHigherPriorityChildIndex(of: index) else {
            return
        }

        if isHigherPriority(at: childIndex, than: index) {
            array.swapAt(index, childIndex)
            bubbleDown(elementAtIndex: childIndex)
        }
    }

    private func getHigherPriorityChildIndex(of index: Int) -> Int? {
        guard index >= 0, index < count else {
            return nil
        }

        let leftChildIndex = getLeftChildIndex(of: index)
        let rightChildIndex = getRightChildIndex(of: index)

        if leftChildIndex >= count {
            return nil
        } else if rightChildIndex >= count {
            return leftChildIndex
        } else {
            return isHigherPriority(at: leftChildIndex, than: rightChildIndex)
                ? leftChildIndex
                : rightChildIndex
        }
    }

    private func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        if min {
            return array[firstIndex].initialPos < array[secondIndex].initialPos
        } else {
            return array[firstIndex].initialPos > array[secondIndex].initialPos
        }
    }
}
