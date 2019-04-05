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

    private let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
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

    private func findArea(_ eq: String, from: Double, to: Double) throws -> Double 
    {
        let firstExp = Expression(eq, constants: [
            "x": to
        ])
        let secondExp = Expression(eq, constants: [
            "x": from
        ])
        return (try firstExp.evaluate()) - (try secondExp.evaluate())
    }

    public func run() throws -> String
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

        return String(try findArea(result, from: 1, to: 2))
    }

}