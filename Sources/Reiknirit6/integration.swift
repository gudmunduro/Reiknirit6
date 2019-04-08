import Common
import Expression

fileprivate struct EPart {
    var valueBefore: Float
    var x: String
    var pow: Float
}

public enum IntegrationError: Error {
    case invalidInput(moreInfo: String)
}

public class Integration {

    private let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let eq: String

    public init(eq: String)
    {
        self.eq = eq
    }

    private func splitEq() -> [String]
    {
        return eq.components(separatedBy: ["+", "-"])
    }

    private func findAllPMOperators() -> [String]
    {
        var result: [String] = []
        for c in eq {
            switch c {
                case "+": result.append("+")
                case "-": result.append("-")
                default: break
            }
        }
        return result
    }

    private func convertPowSymbolToFunction(on value: String) -> String 
    {
        var newValue = ""
        var lastNum = ""
        var inPow = false
        var inNum = false
        var counter = 0
        var lastX = ""

        mainFor: for c in value {
            switch c {
                case "^":
                    inPow = true
                    inNum = false
                    newValue += "pow(\(lastNum) * \(lastX),"

                case "x", "y", "z":
                    if value[counter - 1] == "*" {
                        newValue = newValue[0..<(newValue.count - 1 - lastNum.count)]
                    }
                    lastX = String(c)

                case _ where numbers.contains(String(c)) || c == ".":
                    if !inNum {
                        inNum = true
                        lastNum = ""
                    }
                    lastNum += String(c)
                    if counter == value.count - 1 { fallthrough }

                case "+", "-", "*", "/", ")", " ":
                    guard inPow else { fallthrough }
                    
                    inPow = false
                    inNum = false
                    newValue += lastNum + ")"
                    guard let lastOfLastNum = lastNum.last else { continue mainFor }
                    if c != lastOfLastNum { newValue += String(c) }

                default:
                    if inNum {
                        newValue += lastNum
                    }
                    inNum = false
                    newValue += String(c)
            }
            counter++
        }
        
        return newValue
    }

    private func splitSinglePart(_ e: String) -> EPart
    {
        var part = 0
        var result: [String] = []
        for c in e {
            if result.count < part + 1 {
                result.append("")
            }
            switch c {
                case _ where numbers.contains(String(c)):
                    result[part] += String(c)
                case "x":
                    part++
                    result.append("")
                    result[part] = "x"
                case "^":
                    part++
                default: break
            }
        }

        let ePart = EPart(valueBefore: Float(result[0])!, x: result[1], pow: Float(result[2])!)

        return ePart
    }

    private func integrate(_ e: String) throws -> String
    {
        var newE = e
        
        switch e {
            case _ where e.contains("sin"):
                guard let startIndex = newE.range(of: "sin("), let endIndex = newE.range(of: ")") else {
                    throw IntegrationError.invalidInput(moreInfo: "value inside sin function not found")
                }
                let inSin = String(newE[startIndex.upperBound...endIndex.lowerBound])

                newE = "-cos(" + inSin + " * " + (try integrate(inSin))
            case _ where e.contains("cos"):
                guard let startIndex = newE.range(of: "cos("), let endIndex = newE.range(of: ")") else {
                    throw IntegrationError.invalidInput(moreInfo: "value inside cos function not found")
                }
                let inCos = String(newE[startIndex.upperBound...endIndex.lowerBound])

                newE = "sin(" + inCos + " * " + (try integrate(inCos))
            case _ where e.contains("x"):
                let componentsByX = newE.components(separatedBy: "")
                if componentsByX.count == 0 || !componentsByX[0].containsFromArray(numbers) {
                    newE = "1" + newE
                }
                if !newE.contains("^") {
                    newE += "^1"
                }

                var epart = splitSinglePart(newE)

                epart.pow += 1
                epart.valueBefore /= epart.pow
                newE = String(epart.valueBefore) + epart.x + "^" + String(epart.pow) 
            default:
                return ""
        }
        return newE
    }

    public func findArea(_ eq: String, from: Double, to: Double) throws -> Double 
    {
        print(eq.replacingOccurrences(of: "x", with: "*x"))
        let newEq = convertPowSymbolToFunction(on: eq.replacingOccurrences(of: "x", with: "*x"))
        print(newEq)
        let firstExp = Expression(newEq, constants: [
            "x": to
        ])
        let secondExp = Expression(newEq, constants: [
            "x": from
        ])
        return (try firstExp.evaluate()) - (try secondExp.evaluate())
    }

    public func fullIntegrate() throws -> String 
    {
        print("a1")
        var result = ""

        let se = splitEq()
        print("a2")
        let op = findAllPMOperators()
        print("a3")
        
        for i in 0..<se.count {
            print("a4.\(i)")
            result += try integrate(se[i])
            
            if op.count > i {
                print("a5.\(i)")
                result += op[i]
            }
        }
        print("a6")

        return result
    }

    public func run(from: Double, to: Double) throws -> String
    {
        var result = ""

        let se = splitEq()
        let op = findAllPMOperators()
        
        for i in 0..<se.count {
            result += try integrate(se[i])
            
            if op.count > i {
                result += op[i]
            }
        }

        return String(try findArea(result, from: from, to: to))
    }

}