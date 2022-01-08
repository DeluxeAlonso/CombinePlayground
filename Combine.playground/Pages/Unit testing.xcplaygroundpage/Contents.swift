import Combine
import XCTest

struct Job {
    let id: String
    let title: String
    let description: String
}

protocol JobClientProtocol {
    func fetchJobs() -> AnyPublisher<[Job], Error>
}

class MockJobClient: JobClientProtocol {
    var fetchJobsResult: AnyPublisher<[Job], Error>!
    func fetchJobs() -> AnyPublisher<[Job], Error> {
        return fetchJobsResult
    }
}

class JobsViewModel {

    private let client: JobClientProtocol

    init(client: JobClientProtocol) {
        self.client = client
    }

    enum JobsViewState: Equatable {
        case populated
        case empty
        case error(_ error: Error)

        static func == (lhs: JobsViewState, rhs: JobsViewState) -> Bool {
            switch (lhs, rhs) {
            case (.populated, .populated): return true
            case (.empty, .empty): return true
            case (.error, .error): return true
            default: return false
            }
        }
    }

    @Published var viewState: JobsViewState = .empty

    func loadJobs() {
        client.fetchJobs()
            .map { jobs -> JobsViewState in
                return jobs.isEmpty ? .empty : .populated
            }.catch { error -> Just<JobsViewState> in
                return Just(.error(error))
            }.assign(to: &$viewState)
    }

}


class JobsViewModelTests: XCTestCase {

    private var mockJobClient: MockJobClient!
    private var viewModelToTest: JobsViewModel!

    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockJobClient = MockJobClient()
        viewModelToTest = JobsViewModel(client: mockJobClient)
    }

    override func tearDownWithError() throws {
        mockJobClient = nil
        viewModelToTest = nil
        try super.tearDownWithError()
    }

    func testGetJobsPopulated() {
        // Arrange
        let jobsToTest = [Job(id: "1", title: "title", description: "desc")]
        let expectation = XCTestExpectation(description: "State is set to populated")
        // Act
        viewModelToTest.$viewState.dropFirst().sink { state in
            XCTAssertEqual(state, .populated)
            expectation.fulfill()
        }.store(in: &cancellables)

        mockJobClient.fetchJobsResult = Result.success(jobsToTest).publisher.eraseToAnyPublisher()
        viewModelToTest.loadJobs()
        // Assert
        wait(for: [expectation], timeout: 1)
    }

    func testGetJobsEmpty() {
        // Arrange
        let jobsToTest: [Job] = []
        let expectation = XCTestExpectation(description: "State is set to empty")
        // Act
        viewModelToTest.$viewState.dropFirst().sink { state in
            XCTAssertEqual(state, .empty)
            expectation.fulfill()
        }.store(in: &cancellables)

        mockJobClient.fetchJobsResult = Result.success(jobsToTest).publisher.eraseToAnyPublisher()
        viewModelToTest.loadJobs()
        // Assert
        wait(for: [expectation], timeout: 1)
    }

}

JobsViewModelTests.defaultTestSuite.run()
