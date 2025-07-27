//
//  PokemonDetailSkeletonView.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct PokemonDetailSkeletonView: View {
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    headerSection(geometry: geometry)
                    contentSection()
                }
            }
        }
        .background(Color(.systemBackground).opacity(0.1))
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }

    private func headerSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    SkeletonView(width: 180, height: 34)
                    SkeletonView(width: 100, height: 24)
                }

                Spacer()

                SkeletonView(width: 30, height: 30)
                    .clipShape(Circle())
            }
            .padding(.horizontal)

            HStack(spacing: 12) {
                SkeletonView(width: 80, height: 30)
                    .clipShape(Capsule())
                SkeletonView(width: 80, height: 30)
                    .clipShape(Capsule())
                Spacer()
            }
            .padding(.horizontal)

            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: CGFloat(280 + index * 40), height: CGFloat(280 + index * 40))
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 2.0 + Double(index) * 0.5).repeatForever(autoreverses: true), value: isAnimating)
                }

                SkeletonView(width: 200, height: 200)
                    .clipShape(Circle())
                    .zIndex(10)
            }

            VStack(spacing: 12) {
                SkeletonView(width: geometry.size.width - 40, height: 28)
                    .clipShape(Capsule())

                HStack {
                    SkeletonView(width: 120, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    SkeletonView(width: 120, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                SkeletonView(width: 200, height: 12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }

    private func contentSection() -> some View {
        VStack(spacing: 0) {
            SkeletonView(width: UIScreen.main.bounds.width - 40, height: 28)
                .clipShape(Capsule())
                .padding(.horizontal)
                .padding(.bottom, 20)

            aboutSkeletonSection()
        }
        .background(Color(.systemBackground))
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }

    private func aboutSkeletonSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    SkeletonView(width: 50, height: 12)
                    SkeletonView(width: 60, height: 16)
                }

                VStack(spacing: 8) {
                    SkeletonView(width: 50, height: 12)
                    SkeletonView(width: 60, height: 16)
                }

                VStack(spacing: 8) {
                    SkeletonView(width: 60, height: 12)
                    SkeletonView(width: 40, height: 16)
                }

                Spacer()
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                SkeletonView(width: 80, height: 20)
                SkeletonView(width: 150, height: 16)
            }
            .padding(.horizontal)

            VStack(spacing: 16) {
                ForEach(0..<6, id: \.self) { _ in
                    HStack {
                        SkeletonView(width: 100, height: 16)
                        Spacer()
                        SkeletonView(width: 200, height: 8)
                            .clipShape(Capsule())
                        SkeletonView(width: 30, height: 16)
                    }
                    .padding(.horizontal)
                }
            }

            Spacer(minLength: 40)
        }
        .padding(.vertical)
    }
}

struct SkeletonView: View {
    let width: CGFloat
    let height: CGFloat
    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: width, height: height)
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.4),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: shimmerOffset * (width + 100))
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: shimmerOffset)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onAppear {
                shimmerOffset = 1
            }
    }
}

#Preview {
    NavigationView {
        PokemonDetailSkeletonView()
            .navigationTitle("Loading...")
            .navigationBarTitleDisplayMode(.inline)
    }
}
