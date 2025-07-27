import SwiftUI
import RxSwift
import Combine

struct PokemonDetailView: View {
    let pokemonName: String
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: PokemonDetailViewModel
    @State private var isFavourite = false
    @State private var selectedSpriteStyle: SpriteStyle = .officialArtwork
    @State private var isShinyVariant = false
    @State private var selectedTab: DetailTab = .about
    @State private var currentSpriteIndex = 0
    @State private var isRotating = false
    @State private var rotationAngle: Double = 0
    @State private var isFrontView = true
    @State private var spriteScale: CGFloat = 1.0
    @State private var animationTimer: Timer?
    
    enum SpriteStyle: String, CaseIterable {
        case officialArtwork = "Official Artwork"
        case homeStyle = "Home Style"
        case gameSprites = "Game Sprites"
        
        var supportsBackView: Bool {
            return self == .gameSprites
        }
        
        var description: String {
            switch self {
            case .officialArtwork:
                return "High-quality official artwork"
            case .homeStyle:
                return "Pokemon Home style sprites"
            case .gameSprites:
                return "Classic pixelated game sprites"
            }
        }
    }
    
    enum DetailTab: String, CaseIterable {
        case about = "About"
        case stats = "Stats"
        case moves = "Moves"
        case abilities = "Abilities"
    }
    
    init(pokemonName: String, getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol) {
        self.pokemonName = pokemonName
        self._viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemonName: pokemonName, getPokemonDetailUseCase: getPokemonDetailUseCase))
    }
    
    var body: some View {
        ZStack {
            if let pokemon = viewModel.pokemon {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 0) {
                            headerSection(pokemon: pokemon, geometry: geometry)
                            contentSection(pokemon: pokemon)
                        }
                    }
                }
                .background(primaryTypeColor(pokemon: pokemon).opacity(0.1))
            } else if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.error {
                errorView(error: error)
            }
        }
        .navigationTitle(pokemonName.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadPokemonDetail()
        }
    }
    
    private func headerSection(pokemon: PokemonDetail, geometry: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(pokemon.formattedName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(pokemon.pokemonNumber)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    isFavourite.toggle()
                }) {
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavourite ? .red : .gray)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 12) {
                ForEach(pokemon.types) { type in
                    TypeBadge(type: type.name, color: Color(hex: type.color))
                }
                Spacer()
            }
            .padding(.horizontal)
            
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [primaryTypeColor(pokemon: pokemon).opacity(0.2 - Double(index) * 0.05), primaryTypeColor(pokemon: pokemon).opacity(0.05)],
                                center: .center,
                                startRadius: 50,
                                endRadius: 150
                            )
                        )
                        .frame(width: CGFloat(280 + index * 40), height: CGFloat(280 + index * 40))
                        .scaleEffect(spriteScale)
                        .rotationEffect(.degrees(Double(index) * 120 + rotationAngle * 0.1))
                        .animation(.easeInOut(duration: 2.0 + Double(index) * 0.5).repeatForever(autoreverses: true), value: spriteScale)
                        .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: rotationAngle)
                }
                
                AnimatedSpriteView(
                    pokemon: pokemon,
                    selectedStyle: selectedSpriteStyle,
                    isShiny: isShinyVariant,
                    isFrontView: $isFrontView,
                    rotationAngle: $rotationAngle,
                    onTap: {
                        if selectedSpriteStyle.supportsBackView {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                isFrontView.toggle()
                                rotationAngle += 180
                            }
                        }
                    }
                )
                .frame(width: 200, height: 200)
                .zIndex(10)
            }
            .onAppear {
                spriteScale = 1.05
                startSpriteAnimation()
            }
            .onDisappear {
                stopSpriteAnimation()
            }
            
            VStack(spacing: 12) {
                Picker("Sprite Style", selection: $selectedSpriteStyle) {
                    ForEach(SpriteStyle.allCases, id: \.self) { style in
                        Text(style.rawValue).tag(style)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedSpriteStyle) { _, newStyle in
                    if !newStyle.supportsBackView && !isFrontView {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            isFrontView = true
                            rotationAngle = 0
                        }
                    }
                }
                
                HStack {
                    HStack(spacing: 8) {
                        Text("Shiny")
                            .font(.caption)
                            .foregroundColor(.primary)
                        Toggle("", isOn: $isShinyVariant)
                            .toggleStyle(SwitchToggleStyle(tint: primaryTypeColor(pokemon: pokemon)))
                            .labelsHidden()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    
                    if selectedSpriteStyle.supportsBackView {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                isFrontView.toggle()
                                rotationAngle += 180
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.caption)
                                Text(isFrontView ? "Back" : "Front")
                                    .font(.caption)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(primaryTypeColor(pokemon: pokemon).opacity(0.2))
                            .foregroundColor(primaryTypeColor(pokemon: pokemon))
                            .cornerRadius(12)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Text(selectedSpriteStyle.description + (selectedSpriteStyle.supportsBackView ? " • Tap to flip" : ""))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
    
    private func contentSection(pokemon: PokemonDetail) -> some View {
        VStack(spacing: 0) {
            Picker("Detail Tab", selection: $selectedTab) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            switch selectedTab {
            case .about:
                aboutSection(pokemon: pokemon)
            case .stats:
                statsSection(pokemon: pokemon)
            case .moves:
                movesSection(pokemon: pokemon)
            case .abilities:
                abilitiesSection(pokemon: pokemon)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
    
    private func aboutSection(pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("Height")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.heightInMeters, specifier: "%.1f") m")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                VStack(spacing: 8) {
                    Text("Weight")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.weightInKilograms, specifier: "%.1f") kg")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                VStack(spacing: 8) {
                    Text("Base EXP")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.baseExperience)")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Species")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(pokemon.species.capitalized)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Spacer(minLength: 40)
        }
        .padding(.vertical)
    }
    
    private func statsSection(pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(pokemon.stats) { stat in
                StatRow(
                    name: stat.name.replacingOccurrences(of: "-", with: " ").capitalized,
                    value: stat.value,
                    maxValue: 200,
                    color: primaryTypeColor(pokemon: pokemon)
                )
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    private func movesSection(pokemon: PokemonDetail) -> some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(Array(pokemon.moves.prefix(20))) { move in
                MoveRow(move: move)
            }
            
            if pokemon.moves.count > 20 {
                Text("... and \(pokemon.moves.count - 20) more moves")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    private func abilitiesSection(pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(pokemon.abilities) { ability in
                AbilityRow(ability: ability)
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading \(pokemonName.capitalized)...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Oops! Something went wrong")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                viewModel.loadPokemonDetail()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func primaryTypeColor(pokemon: PokemonDetail) -> Color {
        guard let firstType = pokemon.types.first else { return Color.gray }
        return Color(hex: firstType.color)
    }
    
    private func startSpriteAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                if currentSpriteIndex < 3 {
                    currentSpriteIndex += 1
                } else {
                    currentSpriteIndex = 0
                }
            }
        }
    }
    
    private func stopSpriteAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

struct TypeBadge: View {
    let type: String
    let color: Color
    
    var body: some View {
        Text(type.capitalized)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
    }
}

struct StatRow: View {
    let name: String
    let value: Int
    let maxValue: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(name)
                .font(.body)
                .fontWeight(.medium)
                .frame(width: 80, alignment: .leading)
            
            Text("\(value)")
                .font(.body)
                .fontWeight(.semibold)
                .frame(width: 40, alignment: .trailing)
            
            ProgressView(value: Double(value), total: Double(maxValue))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(height: 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
        }
    }
}

struct MoveRow: View {
    let move: PokemonMove
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(move.formattedName)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(move.formattedLearnMethod)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct AbilityRow: View {
    let ability: PokemonAbility
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(ability.formattedName)
                    .font(.body)
                    .fontWeight(.medium)
                
                if ability.isHidden {
                    Text("Hidden Ability")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct AnimatedSpriteView: View {
    let pokemon: PokemonDetail
    let selectedStyle: PokemonDetailView.SpriteStyle
    let isShiny: Bool
    @Binding var isFrontView: Bool
    @Binding var rotationAngle: Double
    let onTap: () -> Void
    
    @State private var bounceScale: CGFloat = 1.0
    @State private var floatOffset: CGFloat = 0
    
    var body: some View {
        let currentImageURL = pokemon.sprites.getSpriteForStyle(
            selectedStyle.rawValue,
            isShiny: isShiny,
            isFront: isFrontView
        )
        
        AsyncImage(url: URL(string: currentImageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(bounceScale)
                .offset(y: floatOffset)
                .rotation3DEffect(
                    .degrees(rotationAngle),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.5
                )
                .onTapGesture {
                    withAnimation(.bouncy(duration: 0.3)) {
                        bounceScale = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.bouncy(duration: 0.3)) {
                            bounceScale = 1.0
                        }
                    }
                    onTap()
                }
                .onAppear {
                    startFloatingAnimation()
                }
        } placeholder: {
            ProgressView()
                .scaleEffect(1.5)
        }
    }
    
    private func startFloatingAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            floatOffset = -10
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: PokemonDetail?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let pokemonName: String
    private let getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(pokemonName: String, getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol) {
        self.pokemonName = pokemonName
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
    }
    
    func loadPokemonDetail() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        let pokemonId = extractIdFromName(pokemonName)
        
        getPokemonDetailUseCase
            .execute(id: pokemonId)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] pokemon in
                    self?.pokemon = pokemon
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.error = error
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func extractIdFromName(_ name: String) -> Int {
        let lowercasedName = name.lowercased()
        let pokemonNameToIdMap: [String: Int] = [
            "bulbasaur": 1, "ivysaur": 2, "venusaur": 3,
            "charmander": 4, "charmeleon": 5, "charizard": 6,
            "squirtle": 7, "wartortle": 8, "blastoise": 9,
            "caterpie": 10, "metapod": 11, "butterfree": 12,
            "weedle": 13, "kakuna": 14, "beedrill": 15,
            "pidgey": 16, "pidgeotto": 17, "pidgeot": 18,
            "rattata": 19, "raticate": 20, "spearow": 21,
            "fearow": 22, "ekans": 23, "arbok": 24,
            "pikachu": 25, "raichu": 26, "sandshrew": 27,
            "sandslash": 28, "nidoran-f": 29, "nidorina": 30,
            "nidoqueen": 31, "nidoran-m": 32, "nidorino": 33,
            "nidoking": 34, "clefairy": 35, "clefable": 36,
            "vulpix": 37, "ninetales": 38, "jigglypuff": 39,
            "wigglytuff": 40, "zubat": 41, "golbat": 42,
            "oddish": 43, "gloom": 44, "vileplume": 45,
            "paras": 46, "parasect": 47, "venonat": 48,
            "venomoth": 49, "diglett": 50
        ]
        
        return pokemonNameToIdMap[lowercasedName] ?? 1
    }
}