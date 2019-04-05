import Common
import Files

func parseTriangleFromFile() throws -> [[Int]] {
    let file = try Folder.current.file(named: "triangle.txt")

    let triangleFileData = try file.readAsString()
    let triangleFileDataLines = triangleFileData.components(separatedBy: "\n")
    var resultArray: [[Int]] = []
    resultArray.reserveCapacity(triangleFileDataLines.count)
    
    linesLoop: for (i, line) in zip(0..<triangleFileDataLines.count, triangleFileDataLines) {

        resultArray.append([])
        let numbers = line.components(separatedBy: " ")
        numberLoop: for num in numbers {
            guard let numAsInt = Int(num) else {
                continue numberLoop
            }
            resultArray[i].append(numAsInt)
        }
    }
    return resultArray
}

func maxSumPath(of triangle: [[Int]]) -> Int {
    if triangle.count == 1 {
        return triangle[0][0]
    }
    var newTriangle = triangle
    
    for i in 0..<newTriangle[newTriangle.count - 1].count {
        guard newTriangle[newTriangle.count - 2].count > i else {
            break
        }
        newTriangle[newTriangle.count - 2][i] += max(newTriangle[newTriangle.count - 1][i], newTriangle[newTriangle.count - 1][i+1])
    }
    newTriangle.popLast()
    return maxSumPath(of: newTriangle)
}

func runPart2() {
    guard let triangle = try? parseTriangleFromFile() else {
        print("Failed to parse triangle.txt")
        return
    }
    print("Hæsta summa \(maxSumPath(of: triangle))")
}