import Common


// ***
// Node
// ***
fileprivate class Node {

    var value: Int
    var left: Node?
    var right: Node?

    init(_ value: Int) {
        self.value = value
    }
}

// Functions
fileprivate extension Node {

    var hasAnyChildren: Bool {
        return right != nil || left != nil
    }

    var hasBothChildren: Bool {
        return right != nil && left != nil
    }

    func insert(_ value: Int) -> Bool {
        guard self.value != value else {
            return false
        }

        if self.value > value {
            if let left = self.left {
                return left.insert(value)
            } else {
                self.left = Node(value)
                return true
            }
        } else {
            if let right = self.right {
                return right.insert(value)
            } else {
                self.right = Node(value)
                return true
            }
        }
    }

    func findParent(_ value: Int) -> Node? {
        if self.value > value {
            guard let left = self.left else {
                return nil
            }
            if value == left.value {
                return self
            } else {
                return left.findParent(value)
            }
        } else {
            guard let right = self.right else {
                return nil
            }
            if value == right.value {
                return self
            } else {
                return right.findParent(value)
            }
        }
        return nil
    }

    func preOrderPrint() {
        print(value, terminator: ", ")
        if let left = self.left {
            left.preOrderPrint()
        }
        if let right = self.right {
            right.preOrderPrint()
        }
    }

    func postOrderPrint() {
        if let left = self.left {
            left.postOrderPrint()
        }
        if let right = self.right {
            right.postOrderPrint()
        }
        print(value, terminator: ", ")
    }

    private func findInorderSuccessor() -> Node
    {
        var currentLowest = self
        if let left = self.left {
            let ios = left.findInorderSuccessor()
            if ios.value < value {
                currentLowest  = ios
            }
        }
        if let right = self.right {
            let ios = right.findInorderSuccessor()
            if ios.value < value {
                currentLowest  = ios
            }
        }
        return currentLowest
    }

    private func deleteThis(parent: Node) {
        if !hasAnyChildren {
            if parent.left === self {
                parent.left = nil
            } else if parent.right === self {
                parent.right = nil
            }
        } else if hasAnyChildren && !hasBothChildren {
            if left != nil {
                if parent.left === self {
                    parent.left = left
                } else if parent.right === self {
                    parent.right = left
                }
            }
            if right != nil {
                if parent.left === self {
                    parent.left = right
                } else if parent.right === self {
                    parent.right = right
                }
            }
        } else {
            let ios = right!.findInorderSuccessor()
            value = ios.value
            guard let parent = try! findParent(ios.value) else {
                return
            }
            ios.deleteThis(parent: parent)
        }
    }

    func delete(_ value: Int) -> Bool {value
        if self.value > value {
            guard let left = self.left else {
                return false
            }

            if left.value == value {
                left.deleteThis(parent: self)
                return true
            } else {
                return left.delete(value)
            }
        } else {
            guard let right = self.right else {
                return false
            }

            if right.value == value {
                right.deleteThis(parent: self)
                return true
            } else {
                return right.delete(value)
            }
        }
    }
}



// ***
// Tree
// ***
fileprivate class Tree {

    var root: Node?

    init() { }

    init(root: Node) {
        self.root = root
    }

    init(value: Int) {
        self.root = Node(value)
    }
}

// Functions
fileprivate extension Tree {

    func insert(_ value: Int) -> Bool {
        if var root = self.root {
            return root.insert(value)
        } else {
            self.root = Node(value)
            return true
        }
    }

    func preOrderPrint() {
        if let root = self.root {
            root.preOrderPrint()
        } else {
            print("Tréið er tómt")
            
        }
    }

    func postOrderPrint() {
        if let root = self.root {
            root.postOrderPrint()
        } else {
            print("Tréið er tómt")
            
        }
    }

    func delete(_ value: Int) -> Bool {
        if let root = self.root {
            if root.value == value {
                self.root = root.left
                return true
            } else {
                return root.delete(value)
            }
        } else {
            print("Tréið er tómt")
            return false
        }
    }

    func deleteTree() {
        root = nil // Eyðir reference á rótina og lætur ARC(Automatic Reference Counting) sjá um restina
    }
}



// ***
// Run func
// ***

func runPart3()
{
    let tree = Tree()
    tree.insert(4)
    tree.insert(3)
    tree.insert(2)
    tree.insert(8)
    tree.insert(6)
    tree.insert(10)
    tree.insert(20)
    tree.postOrderPrint()
    print()
    tree.delete(8)
    tree.postOrderPrint()
}