import Foundation
struct MathQuestion {
    let text: String
    let correctAnswer: Int
}
struct MathEngine {
    static func generateQuestion(number: Int) -> MathQuestion {
        let num1 = Int.random(in: 1...12)
        let num2 = Int.random(in: 1...12)
        let operations = ["+", "-", "×"]
        let chosenOp = operations.randomElement() ?? "+"
        switch chosenOp {
        case "-":
            let maxNum = max(num1, num2)
            let minNum = min(num1, num2)
            return MathQuestion(text: "\(maxNum) - \(minNum)", correctAnswer: maxNum - minNum)
        case "×":
            return MathQuestion(text: "\(num1) × \(num2)", correctAnswer: num1 * num2)
        default:
            return MathQuestion(text: "\(num1) + \(num2)", correctAnswer: num1 + num2)
        }
    }
}
