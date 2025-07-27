# PokedexPocket

## TL;DR

📱 **What**: Advanced iOS Pokédex app built with SwiftUI showcasing Clean Architecture  
🏗️ **Architecture**: Clean Architecture + MVVM + Dependency Injection + Repository Pattern  
🔧 **Tech Stack**: SwiftUI, RxSwift, Alamofire, Swinject, SwiftData  
🎯 **Features**: Browse 1000+ Pokémon, real-time search, detailed stats, favorites with animations  
📦 **Size**: Production-ready with comprehensive error handling and caching  

---

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [📱 Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🛠️ Tech Stack](#️-tech-stack)
- [📚 Project Structure](#-project-structure)
- [🎨 Key Components](#-key-components)
- [🔧 Setup & Installation](#-setup--installation)
- [📡 API Integration](#-api-integration)
- [🎯 Code Examples](#-code-examples)
- [🧪 Testing](#-testing)
- [📝 Development Guidelines](#-development-guidelines)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🚀 Quick Start

### Prerequisites
- **Xcode**: 15.0+ (iOS 17.0+)
- **Swift**: 5.9+
- **iOS Deployment Target**: 17.0+

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/PokedexPocket.git
cd PokedexPocket

# Open in Xcode
open PokedexPocket.xcodeproj

# Build and run (⌘+R)
```

## 📱 Features

### Core Features
- **🏠 Pokémon List**: Grid-based infinite scrolling list of 1000+ Pokémon
- **🔍 Real-time Search**: Instant search with debouncing and filtering
- **📊 Detailed Stats**: Comprehensive Pokémon information including:
  - Base stats with visual representations
  - Type effectiveness and weaknesses  
  - Abilities with hidden ability indicators
  - Move sets with learn methods and levels
  - Physical characteristics (height, weight, base experience)
- **⭐ Favorites System**: Persistent favorites with SwiftData integration
- **🎨 Sprite Gallery**: Multiple sprite views (official artwork, game sprites, shiny variants)
- **🔊 Audio Cries**: Pokémon audio cries integration
- **👨‍💻 About Developer**: Profile page with skills and social links

### UI/UX Features
- **💫 Smooth Animations**: Engaging transitions and micro-interactions
- **⚡ Skeleton Loading**: Shimmer effects during data loading
- **🎨 Type-based Theming**: Dynamic colors based on Pokémon types
- **📱 Responsive Design**: Optimized for all iPhone screen sizes
- **♿ Accessibility**: VoiceOver support and accessibility identifiers
- **🌙 Adaptive Interface**: Supports both light and dark mode

### Performance Features
- **🚀 Lazy Loading**: Efficient memory management with lazy grids
- **💾 Smart Caching**: 50MB memory + 200MB disk cache for images
- **🔄 Network Resilience**: Retry mechanisms and error handling
- **⚡ Debounced Search**: Optimized search to reduce API calls

## 🏗️ Architecture

### Clean Architecture Overview

The app follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│              Presentation Layer         │
│  ┌─────────────┐    ┌─────────────────┐ │
│  │    Views    │◄──►│  ViewModels     │ │
│  │  (SwiftUI)  │    │   (RxSwift)     │ │
│  └─────────────┘    └─────────────────┘ │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│               Domain Layer              │
│  ┌─────────────┐    ┌─────────────────┐ │
│  │  Entities   │    │   Use Cases     │ │
│  │ (Business   │    │  (Business      │ │
│  │   Models)   │    │    Logic)       │ │
│  └─────────────┘    └─────────────────┘ │
│         ▲                    │          │
│         │            ┌───────▼───────┐  │
│         │            │  Repository   │  │
│         │            │  Protocols    │  │
│         │            └───────────────┘  │
└─────────┼────────────────────┬──────────┘
          │                    │
┌─────────▼────────────────────▼──────────┐
│                Data Layer               │
│  ┌─────────────┐    ┌─────────────────┐ │
│  │ Repository  │    │   Network       │ │
│  │Implementatn │    │   Service       │ │
│  └─────────────┘    └─────────────────┘ │
│         ▲                    ▲          │
│  ┌──────┴───────┐    ┌────────┴───────┐ │
│  │   Models     │    │   Alamofire    │ │
│  │(API Response)│    │   Manager      │ │
│  └──────────────┘    └────────────────┘ │
└─────────────────────────────────────────┘
```

### Architecture Layers

#### 1. **Presentation Layer**
- **Views**: SwiftUI views with declarative UI
- **ViewModels**: MVVM pattern with RxSwift for reactive programming
- **Navigation**: Coordinator pattern for navigation flow

#### 2. **Domain Layer** 
- **Entities**: Core business models (Pokemon, PokemonDetail)
- **Use Cases**: Business logic implementation
- **Repository Protocols**: Abstraction for data access

#### 3. **Data Layer**
- **Repository Implementations**: Concrete data access implementations
- **Network Service**: API communication layer
- **Models**: Data transfer objects and API response models

### Dependency Injection

Using **Swinject** for IoC container:

```swift
// DIContainer registration example
container.register(PokemonListRepositoryProtocol.self) { resolver in
    let networkService = resolver.resolve(NetworkServiceProtocol.self)!
    return PokemonListRepository(networkService: networkService)
}.inObjectScope(.container)
```

## 🛠️ Tech Stack

### Core Technologies

| Category | Technology | Version | Purpose |
|----------|------------|---------|---------|
| **UI Framework** | SwiftUI | iOS 17.0+ | Declarative UI development |
| **Reactive Programming** | RxSwift | 6.6.0 | Reactive data binding |
| **Reactive Extensions** | RxCocoa | 6.6.0 | UIKit reactive extensions |
| **Networking** | Alamofire | 5.8.0 | HTTP networking |
| **Dependency Injection** | Swinject | 2.8.0 | IoC container |
| **Local Persistence** | SwiftData | iOS 17.0+ | Core Data successor |
| **Architecture** | Clean Architecture + MVVM | - | Separation of concerns |

### Additional Dependencies

```swift
// Package.swift dependencies
.package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
.package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.6.0"),  
.package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
```

## 📚 Project Structure

### Detailed Directory Structure

```
PokedexPocket/
├── 📱 PokedexPocketApp.swift           # App entry point
├── 📁 Configuration/                   # App configuration
│   └── Environment.plist              # Environment variables
├── 📁 Core/                           # Shared components & utilities
│   ├── 📁 Components/                 # Reusable UI components
│   │   ├── AbilityRow.swift          # Ability display component
│   │   ├── AnimatedSpriteView.swift   # Animated Pokémon sprites
│   │   ├── ErrorView.swift           # Error state UI
│   │   ├── FavouritePokemonCard.swift # Favorite Pokémon cards
│   │   ├── FeatureRow.swift          # Feature list component
│   │   ├── LoadingView.swift         # Loading state UI
│   │   ├── MoveRow.swift             # Move display component
│   │   ├── PokemonCard.swift         # Main Pokémon card
│   │   ├── PokemonDetailSkeletonView.swift # Skeleton loading
│   │   ├── SkillBadge.swift          # Skill badge component
│   │   ├── SocialButton.swift        # Social media buttons
│   │   ├── StatRow.swift             # Stat visualization
│   │   └── TypeBadge.swift           # Type badge component
│   ├── 📁 DI/                        # Dependency injection
│   │   └── DIContainer.swift         # Swinject container setup
│   ├── 📁 Data/                      # Core data models
│   │   └── FavouritePokemon.swift    # SwiftData favorite model
│   ├── 📁 Extensions/                # Swift extensions
│   │   ├── Color+Hex.swift           # Color utilities
│   │   └── View+CornerRadius.swift   # View modifiers
│   ├── 📁 Navigation/                # Navigation system
│   │   ├── AppCoordinator.swift      # Navigation coordinator
│   │   └── AppRouter.swift           # Main app router
│   └── 📁 Network/                   # Networking layer
│       ├── AlamofireManager.swift    # Alamofire configuration
│       ├── NetworkConfiguration.swift # Network settings
│       ├── 📁 Endpoints/             # API endpoints
│       │   ├── APIEndpoint.swift     # Base endpoint protocol
│       │   └── PokemonEndpoints.swift # Pokémon API endpoints
│       └── 📁 Services/              # Network services
│           └── NetworkService.swift   # Core network service
├── 📁 Features/                       # Feature modules
│   ├── 📁 About/                     # About developer page
│   │   └── 📁 Presentation/
│   │       └── AboutDevView.swift    # About page view
│   ├── 📁 Favourites/                # Favorites management
│   │   └── 📁 Presentation/
│   │       └── FavouritePokemonView.swift # Favorites list view
│   ├── 📁 PokemonDetail/             # Detailed Pokémon view
│   │   ├── 📁 Data/                  # Data layer
│   │   │   ├── 📁 Network/Models/
│   │   │   │   └── PokemonDetailResponse.swift # API response model
│   │   │   └── 📁 Repositories/
│   │   │       └── PokemonDetailRepository.swift # Data repository
│   │   ├── 📁 Domain/                # Business logic layer
│   │   │   ├── 📁 Entities/
│   │   │   │   └── PokemonDetail.swift # Domain model
│   │   │   ├── 📁 Repositories/
│   │   │   │   └── PokemonDetailRepositoryProtocol.swift # Repository contract
│   │   │   └── 📁 UseCases/
│   │   │       └── GetPokemonDetailUseCase.swift # Business logic
│   │   └── 📁 Presentation/          # UI layer
│   │       ├── PokemonDetailView.swift # Detail view
│   │       └── PokemonDetailViewModel.swift # View model
│   └── 📁 PokemonList/               # Pokémon listing feature
│       ├── 📁 Data/                  # Data layer
│       │   ├── 📁 Network/Models/
│       │   │   └── PokemonListResponse.swift # API response model
│       │   └── 📁 Repositories/
│       │       └── PokemonListRepository.swift # Data repository
│       ├── 📁 Domain/                # Business logic layer
│       │   ├── 📁 Entities/
│       │   │   ├── Pokemon.swift     # Pokemon entity
│       │   │   └── PokemonList.swift # Pokemon list entity
│       │   ├── 📁 Repositories/
│       │   │   └── PokemonListRepositoryProtocol.swift # Repository contract
│       │   └── 📁 UseCases/
│       │       ├── GetPokemonListUseCase.swift # Get list use case
│       │       └── SearchPokemonUseCase.swift # Search use case
│       └── 📁 Presentation/          # UI layer
│           ├── PokemonListView.swift # List view
│           └── PokemonListViewModel.swift # View model
├── 📁 Assets.xcassets/               # App assets
│   ├── AppIcon.appiconset/          # App icons
│   ├── About.imageset/              # About page images
│   └── AccentColor.colorset/        # App accent colors
├── 📁 PokedexPocketTests/           # Unit tests
└── 📁 PokedexPocketUITests/         # UI tests
```

## 🎨 Key Components

### Core UI Components

#### PokemonCard
```swift
struct PokemonCard: View {
    let pokemon: Pokemon
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Pokemon image with loading state
            AsyncImage(url: URL(string: pokemon.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(height: 120)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.pokemonNumber)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(pokemon.formattedName)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 4) {
                    ForEach(pokemon.types, id: \.self) { type in
                        TypeBadge(type: type)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}
```

#### AnimatedSpriteView
Advanced sprite animation component supporting multiple sprite styles:
- Official Artwork
- Game Sprites (Front/Back)
- Shiny Variants
- Home Style sprites

#### TypeBadge
Dynamic type badges with appropriate colors and styling for all 18 Pokémon types.

### Performance Components

#### PokemonDetailSkeletonView
Shimmer loading effects that maintain layout structure during data loading:

```swift
struct PokemonDetailSkeletonView: View {
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 16) {
            // Header skeleton
            RoundedRectangle(cornerRadius: 12)
                .fill(shimmerGradient)
                .frame(height: 200)
            
            // Content skeletons
            VStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(shimmerGradient)
                        .frame(height: 44)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                animationPhase = 1
            }
        }
    }
    
    private var shimmerGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.1), 
                Color.gray.opacity(0.3)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .rotationEffect(.degrees(animationPhase * 360))
    }
}
```

## 🔧 Setup & Installation

### Development Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/PokedexPocket.git
   cd PokedexPocket
   ```

2. **Open in Xcode**
   ```bash
   open PokedexPocket.xcodeproj
   ```

3. **Install Dependencies**
   - Dependencies are managed via Swift Package Manager
   - Xcode will automatically resolve packages on first build

4. **Configuration**
   - Check `Configuration/Environment.plist` for API settings
   - Default configuration connects to PokéAPI production endpoint

### Build Configurations

| Configuration | Purpose | API Endpoint |
|---------------|---------|--------------|
| Debug | Development | `https://pokeapi.co/api/v2` |
| Release | Production | `https://pokeapi.co/api/v2` |

### Environment Variables

Configure in `Environment.plist`:
```xml
<dict>
    <key>PokeAPIBaseURL</key>
    <string>https://pokeapi.co/api/v2</string>
    <key>Environment</key>
    <string>Development</string>
    <key>APITimeout</key>
    <integer>30</integer>
    <key>MaxRetryAttempts</key>
    <integer>3</integer>
</dict>
```

## 📡 API Integration

### PokéAPI Integration

The app integrates with [PokéAPI v2](https://pokeapi.co/) for comprehensive Pokémon data:

#### Endpoints Used
- **Pokemon List**: `/pokemon?limit=20&offset=0`
- **Pokemon Detail**: `/pokemon/{id}`
- **Pokemon Species**: `/pokemon-species/{id}`

#### Network Configuration
```swift
class NetworkConfiguration {
    static func loadFromEnvironment() -> NetworkConfiguration {
        guard let path = Bundle.main.path(forResource: "Environment", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path) else {
            fatalError("Environment.plist not found")
        }
        
        return NetworkConfiguration(
            baseURL: plist["PokeAPIBaseURL"] as! String,
            timeout: plist["APITimeout"] as! TimeInterval,
            maxRetryAttempts: plist["MaxRetryAttempts"] as! Int
        )
    }
}
```

#### Error Handling
- **Network Errors**: Automatic retry with exponential backoff
- **API Rate Limiting**: Respect rate limits with proper error messaging
- **Offline Support**: Graceful degradation when network unavailable

#### Caching Strategy
```swift
private func configureImageCache() {
    let cache = URLCache(
        memoryCapacity: 50 * 1024 * 1024,  // 50 MB memory
        diskCapacity: 200 * 1024 * 1024,   // 200 MB disk
        diskPath: "image_cache"
    )
    URLCache.shared = cache
}
```

## 🎯 Code Examples

### MVVM with RxSwift

```swift
class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let getPokemonListUseCase: GetPokemonListUseCaseProtocol
    private let searchPokemonUseCase: SearchPokemonUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(getPokemonListUseCase: GetPokemonListUseCaseProtocol,
         searchPokemonUseCase: SearchPokemonUseCaseProtocol) {
        self.getPokemonListUseCase = getPokemonListUseCase
        self.searchPokemonUseCase = searchPokemonUseCase
        
        setupSearch()
        loadInitialData()
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.performSearch(query: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            loadInitialData()
            return
        }
        
        isLoading = true
        
        searchPokemonUseCase.execute(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] searchResults in
                    self?.pokemonList = searchResults
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
}
```

### Repository Pattern Implementation

```swift
protocol PokemonDetailRepositoryProtocol {
    func getPokemonDetail(id: Int) -> Observable<PokemonDetail>
}

class PokemonDetailRepository: PokemonDetailRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPokemonDetail(id: Int) -> Observable<PokemonDetail> {
        return networkService
            .request(endpoint: PokemonEndpoints.pokemonDetail(id: id))
            .map { (response: PokemonDetailResponse) in
                response.toDomain()
            }
    }
}
```

### Use Case Implementation

```swift
protocol GetPokemonDetailUseCaseProtocol {
    func execute(id: Int) -> Observable<PokemonDetail>
}

class GetPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol {
    private let repository: PokemonDetailRepositoryProtocol
    
    init(repository: PokemonDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int) -> Observable<PokemonDetail> {
        guard id > 0 else {
            return Observable.error(ValidationError.invalidPokemonId)
        }
        
        return repository.getPokemonDetail(id: id)
            .retry(3)
            .timeout(.seconds(30), scheduler: MainScheduler.instance)
    }
}
```

## 🧪 Testing

### Test Structure

```
PokedexPocketTests/
├── 📁 Core/
│   ├── NetworkServiceTests.swift
│   └── DIContainerTests.swift
├── 📁 Features/
│   ├── 📁 PokemonList/
│   │   ├── PokemonListViewModelTests.swift
│   │   ├── GetPokemonListUseCaseTests.swift
│   │   └── PokemonListRepositoryTests.swift
│   └── 📁 PokemonDetail/
│       ├── PokemonDetailViewModelTests.swift
│       └── GetPokemonDetailUseCaseTests.swift
└── 📁 Mocks/
    ├── MockNetworkService.swift
    ├── MockPokemonRepository.swift
    └── MockData.swift
```

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme PokedexPocket -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test target
xcodebuild test -scheme PokedexPocket -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:PokedexPocketTests/PokemonListViewModelTests
```

### Test Coverage Goals
- **Unit Tests**: >80% code coverage
- **Integration Tests**: Key user flows
- **UI Tests**: Critical user interactions

## 📝 Development Guidelines

### Code Style & Standards

#### Swift Style Guide
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use SwiftLint for code consistency
- Prefer explicit types for clarity
- Use meaningful variable and function names

#### Architecture Principles
1. **Single Responsibility**: Each class/struct has one reason to change
2. **Dependency Inversion**: Depend on abstractions, not concretions
3. **Open/Closed Principle**: Open for extension, closed for modification
4. **Interface Segregation**: Many client-specific interfaces are better than one general-purpose interface

#### File Organization
```
// File header template
//
//  FileName.swift
//  PokedexPocket
//
//  Created by [Name] on [Date].
//

import Foundation
// Additional imports...

// MARK: - Protocol/Class/Struct Definition

// MARK: - Public Methods

// MARK: - Private Methods

// MARK: - Extensions
```

### Git Workflow

#### Branch Naming
- `feature/pokemon-detail-view`
- `fix/search-crash-issue`
- `refactor/networking-layer`

#### Commit Message Format
```
type(scope): description

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Performance Best Practices

1. **Memory Management**
   - Use `weak` references to avoid retain cycles
   - Dispose RxSwift subscriptions properly
   - Monitor memory usage with Instruments

2. **Network Optimization**
   - Implement proper caching strategies
   - Use pagination for large datasets
   - Debounce search queries

3. **UI Performance**
   - Use lazy loading for lists
   - Optimize image loading and caching
   - Minimize view redraws

## 🤝 Contributing

### How to Contribute

1. **Fork the Repository**
2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make Changes**
   - Follow coding standards
   - Add tests for new features
   - Update documentation if needed
4. **Submit Pull Request**
   - Provide clear description
   - Include screenshots for UI changes
   - Ensure all tests pass

### Development Setup for Contributors

1. Install development dependencies
2. Run tests to ensure everything works
3. Set up SwiftLint for code style consistency
4. Configure git hooks for pre-commit checks

### Code Review Process

- All changes require code review
- Automated checks must pass
- Documentation updates for new features
- Performance impact assessment for significant changes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📊 Project Stats

- **Lines of Code**: ~3,000+ Swift lines
- **Components**: 15+ reusable UI components  
- **Features**: 4 main feature modules
- **Test Coverage**: 80%+ (target)
- **Dependencies**: 3 external packages
- **Supported iOS**: 17.0+

---

## 🙏 Acknowledgments

- **PokéAPI**: For providing comprehensive Pokémon data
- **Alamofire**: For robust networking capabilities
- **RxSwift**: For reactive programming paradigms
- **Swinject**: For dependency injection framework
- **Apple**: For SwiftUI and SwiftData frameworks

---

## 📞 Support & Contact

For questions, suggestions, or support:

- **GitHub Issues**: [Create an issue](https://github.com/yourusername/PokedexPocket/issues)
- **Email**: your.email@example.com
- **LinkedIn**: [Your LinkedIn Profile](https://linkedin.com/in/yourprofile)

---

*Built with ❤️ by Azri using modern iOS development practices*