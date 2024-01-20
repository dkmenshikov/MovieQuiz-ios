import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Переменные сторонних сущностей
    
    private var presenter: MovieQuizPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)

        setActivityIndicator(isHidden: false)
        
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
    
    
    // MARK: - Метод отображения ошибки загрузки
    
    func showNetworkError(message: String) {
        setActivityIndicator(isHidden: true)
        
        let alertModel: AlertModel = AlertModel(title: "Ошибка",
                                                text: message,
                                                buttonText: "Попробовать еще раз",
                                                completion: { [weak self] _ in
            self?.presenter?.restartGame()
            print("нажатие повторной попытки загрузки данных с сервера")
        })
        
        presenter?.alertPresenter.showAlert(alertModel: alertModel)
    }
    
    
    // MARK: - Метод показа модели этапа квиза
    
    func showStep(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showResult(quiz result: AlertModel) {
        presenter?.alertPresenter.showAlert(alertModel: result)
        print ("Показ алерта")
    }
    
    
    // MARK: - Метод показа результата ответа
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
        yesButton.isEnabled = false
        noButton.isEnabled = false

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            imageView.layer.borderWidth = 0
            
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }

    
    // MARK: - IBAction для кнопок ДА НЕТ
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        print("нажатие ДА")
        presenter?.yesButtonClicked()
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        print("нажатие НЕТ")
        presenter?.noButtonClicked()
    }
    
}
