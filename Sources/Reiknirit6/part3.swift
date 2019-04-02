import Common

class Node {

    let value: Int
    var left: Node?
    var right: Node?

    init(_ value: Int)
    {
        self.value = value
    }

    func insert(_ data: Int) -> Bool
    {
        guard self.value != data else {
            return false
        }
        if self.value > data {
            if let left = self.left {
                return left.insert(data)
            } else {
                self.left = Node(data)
                return true
            }
        } else {
            if let right = self.right {
                return right.insert(data)
            } else {
                self.right = Node(data)
                return true
            }
        }
    }
}

class Tree {

    var root: Node?

    func insert(data: Int) -> Bool {
        if var root = self.root {
            return root.insert(data)
        } else {
            self.root = Node(data)
            return true
        }
    }

    func preOrderPrint()
    {

    }

    func postOrderPrint()
    {

    }

    func delete()
    {

    }

    func deleteTree()
    }
}

func runPart3()
{

}