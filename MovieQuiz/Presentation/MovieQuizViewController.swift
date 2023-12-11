import UIKit

final class MovieQuizViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel.init(
            image: UIImage.init(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
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
        let action = UIAlertAction(title: step.buttonText, style: .default) { [weak self] _ in
            guard let self else {
                return
            }
            print("нажатие повторной игры")
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            guard let firstQuestion = questionFactory.requestNextQuestion() else {
                return
            }
            currentQuestion = firstQuestion
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult (isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {
            print("ответ верный")
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            print("ответ НЕверный")
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {
                return
            }
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults () {
        if currentQuestionIndex == questionsAmount - 1 {
            let viewModel = QuizResultsViewModel (title: "Этот раунд окончен",
                                                  text: "Результат \(correctAnswers) правильных ответов",
                                                  buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            guard let nextQuestion = questionFactory.requestNextQuestion() else {
                return
            }
            currentQuestion = nextQuestion
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }

    
    @IBAction func yesButtonClicked(_ sender: Any) {
        print("нажатие ДА")
        if let currentQuestion {
            showAnswerResult(isCorrect: currentQuestion.correctAnswer)
        }
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        print("нажатие НЕТ")
        if let currentQuestion {
            showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
        }
    }
    
}
