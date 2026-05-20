import SwiftUI

struct ContentView: View {
    @State private var currentQuestion = "Loading..."
    @State private var correctAnswer = ""
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var questionNumber = 1
    @State private var feedbackMessage = ""
    @State private var isCorrect: Bool? = nil
    
    let targetQuestions = 8080
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        // Enforce phone dimensions and appearance
        VStack(spacing: 0) {
            // Top Status Bar Area Mock
            Text("If account deletion is requested, Please contact iamvihaan209.new@gmail.com")
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(.secondary.opacity(0.7))
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.02))
                
            Spacer()

            // Main Phone Content UI
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("MathsApp9")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text("Progress: \(questionNumber) / \(targetQuestions)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: resetGame) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.orange)
                            .padding(8)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                ProgressView(value: Double(questionNumber), total: Double(targetQuestions))
                    .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                
                VStack(spacing: 8) {
                    Text("SOLVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .tracking(2)
                    Text(currentQuestion)
                        .font(.system(size: 46, weight: .semibold, design: .rounded))
                    Text(userAnswer.isEmpty ? "?" : userAnswer)
                        .font(.system(size: 36, weight: .heavy, design: .monospaced))
                        .foregroundColor(userAnswer.isEmpty ? .secondary : .accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                
                if let result = isCorrect {
                    HStack {
                        Image(systemName: result ? "checkmark.circle.fill" : "xmark.circle.fill")
                        Text(feedbackMessage)
                    }
                    .foregroundColor(result ? .green : .red)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(result ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(8)
                } else {
                    Spacer().frame(height: 40)
                }
                
                HStack {
                    Text("TOTAL SCORE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(score)")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(8)
                
                // Vertical Phone Numpad Layout
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9"], id: \.self) { num in
                        numpadButton(label: num, action: { appendDigit(num) })
                    }
                    numpadButton(label: "C", color: .orange) { userAnswer = "" }
                    numpadButton(label: "0") { appendDigit("0") }
                    numpadButton(label: "⌫", color: .gray) {
                        if !userAnswer.isEmpty { userAnswer.removeLast() }
                    }
                }
                
                Button(action: checkAnswer) {
                    Text("SUBMIT")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(userAnswer.isEmpty ? Color.gray.opacity(0.3) : Color.accentColor)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(userAnswer.isEmpty)
            }
            .padding(.horizontal, 20)
            
            Spacer()

            Text("Licensed under Apache 2.0 License. © Vihaan Singh")
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.secondary.opacity(0.5))
                .padding(.vertical, 12)
        }
        // Force the app frame to match a crisp iPhone 15 aspect ratio layout (393 x 852 points)
        .frame(width: 393, height: 812)
        .background(Color(red: 0.08, green: 0.08, blue: 0.1))
        .preferredColorScheme(.dark)
        .onAppear { generateNextQuestion() }
    }

    @ViewBuilder
    func numpadButton(label: String, color: Color = .white.opacity(0.1), action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(color)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }

    func appendDigit(_ digit: String) {
        if userAnswer.count < 6 { userAnswer += digit }
    }

    func generateNextQuestion() {
        userAnswer = ""
        isCorrect = nil
        let questionData = MathEngine.generateQuestion(number: questionNumber) 
        currentQuestion = questionData.text
        correctAnswer = String(questionData.correctAnswer)
    }

    func checkAnswer() {
        guard !userAnswer.isEmpty else { return }
        if userAnswer.trimmingCharacters(in: .whitespacesAndNewlines) == correctAnswer {
            score += 1
            isCorrect = true
            feedbackMessage = "Correct!"
        } else {
            isCorrect = false
            feedbackMessage = "Wrong! Answer was \(correctAnswer)."
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            questionNumber += 1
            generateNextQuestion()
        }
    }

    func resetGame() {
        score = 0
        questionNumber = 1
        generateNextQuestion()
    }
}
