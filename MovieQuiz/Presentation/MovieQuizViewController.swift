import UIKit

final class MovieQuizViewController: UIViewController {
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // вью модель для состояния "Вопрос показан"
    struct QuizStepViewModel {
      // картинка с афишей фильма с типом UIImage
      let image: UIImage
      // вопрос о рейтинге квиза
      let question: String
      // строка с порядковым номером этого вопроса (ex. "1/10")
      let questionNumber: String
    }
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questions: [QuizQuestion] = [
        QuizQuestion (
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion (
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion (
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion (
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
        ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[0]))
    }
    
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
      // Попробуйте написать код конвертации самостоятельн
        let questionStep = QuizStepViewModel.init(
            image: UIImage.init(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
            )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz step: QuizResultsViewModel) {
        let alert = UIAlertController(title: step.title,
                                      message: step.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: step.buttonText, style: .default) {_ in
            print("нажатие повторной игры")
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult (isCorrect: Bool) {
        //показывает рамку с ответом
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            print("ответ верный")
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            print("ответ НЕверный")
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           // код, который мы хотим вызвать через 1 секунду
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults () {
        if currentQuestionIndex == questions.count - 1 {
            let viewModel = QuizResultsViewModel (title: "Этот раунд окончен", text: "Результат \(correctAnswers) правильных ответов", buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        print("нажатие ДА")
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer)
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        print("нажатие НЕТ")
        showAnswerResult(isCorrect: !questions[currentQuestionIndex].correctAnswer)
    }
    
}
