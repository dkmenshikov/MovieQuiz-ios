import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Свойства класса
    
//    private var currentQuestionIndex = 0
//    var correctAnswers = 0
//    private let questionsAmount: Int = 10
//    private var currentQuestion: QuizQuestion?
    
    // MARK: - Переменные сторонних сущностей
    
//    var questionFactory: QuestionFactoryProtocol?
//    private var alertPresenter: ResultAlertPresenter = ResultAlertPresenter()
    private var presenter: MovieQuizPresenter?
    
//    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
//        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        setActivityIndicator(isHidden: false)
        
//        questionFactory?.loadData()
        
//        alertPresenter.delegate = self // DI через свойство. Сделал не через инит для разнообразия
//        presenter.viewController = self
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        
    }
    
    // MARK: - Метод установки видимости активити индикатора
    
    func setActivityIndicator(isHidden: Bool) {
        activityIndicator.isHidden = isHidden
        if isHidden {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    
//    func didLoadDataFromServer() {
//        setActivityIndicator(isHidden: true)
//        questionFactory?.requestNextQuestion()
//    }
//
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
    
    // MARK: - Метод отображения ошибки загрузки
    
    func showNetworkError(message: String) {
        setActivityIndicator(isHidden: true)
        
        let alertModel: AlertModel = AlertModel(title: "Ошибка",
                                                text: message,
                                                buttonText: "Попробовать еще раз",
                                                completion: { [weak self] _ in
//            self?.presenter.correctAnswers = 0
            
//            self?.currentQuestionIndex = 0
            self?.presenter?.restartGame()
//            self?.presenter?.questionFactory?.requestNextQuestion()
            print("нажатие повторной попытки загрузки данных с сервера")
        })
        
        presenter?.alertPresenter.showAlert(alertModel: alertModel)
    }
    
    // MARK: - QuestionFactoryDelegate
//    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        guard let question else {
//            return
//        }
//        currentQuestion = question
////        let viewModel = convert(model: question)
//        let viewModel = presenter.convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
//    }
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didReceiveNextQuestion(question: question)
//    }
    
    // MARK: - Методы создания и показа модели этапа квиза
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // MARK: - Метод показа результата ответа
    
    func showAnswerResult (isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if isCorrect {
            print("ответ верный")
//            presenter.correctAnswers += 1
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
            self.presenter?.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    // MARK: - Метод показа следующего этапа либо вызова алерта об окончании игры
    
//    private func showNextQuestionOrResults () {
////        currentQuestionIndex += 1
//        presenter.switchToNextQuestion()
////        if currentQuestionIndex == questionsAmount {
//        if presenter.isLastQuestion() {
//            
//            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount) //передаем в сервис сохранения статистики данные о правильных ответах в этой игре. Метод должен изменить сеттеры проперти класса
//            let alertText = """
//                            Ваш результат \(correctAnswers)/\(presenter.questionsAmount)
//                            Количество сыграных квизов: \(statisticService.gamesCount)
//                            Рекорд \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
//                            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
//                            """
//            //подготавливаем текст для печати на алерте из компонентов сервиса
//
//            let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен",
//                                                    text: alertText,
//                                                    buttonText: "Сыграть еще раз",
//                                                    completion: { [weak self] _ in
//                self?.correctAnswers = 0
////                self?.currentQuestionIndex = 0
//                self?.presenter.resetQuestionIndex()
//                self?.questionFactory?.requestNextQuestion()
//                print("нажатие повторной игры")
//            })
//            
//            alertPresenter.showAlert(alertModel: alertModel)
//        } else {
//            self.questionFactory?.requestNextQuestion()
//        }
//    }
    
    // MARK: - IBAction для кнопок ДА НЕТ
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        print("нажатие ДА")
//        if let currentQuestion {
//            showAnswerResult(isCorrect: currentQuestion.correctAnswer)
//        }
//        presenter.currentQuestion = currentQuestion
        presenter?.yesButtonClicked()
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        print("нажатие НЕТ")
//        if let currentQuestion {
//            showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
//        }
//        presenter.currentQuestion = currentQuestion
        presenter?.noButtonClicked()
    }
    
}
