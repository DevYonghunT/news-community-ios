import SwiftUI

// MARK: - 설정 뷰
/// 앱 설정: 프리미엄, 카테고리 선호도, 폰트 크기, 앱 정보
struct SettingsView: View {
    @EnvironmentObject var premiumService: PremiumService
    @StateObject private var viewModel: SettingsViewModel

    init() {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(premiumService: PremiumService()))
    }

    /// 프리미엄 화면 표시 여부
    @State private var showPremium: Bool = false

    var body: some View {
        List {
            // MARK: - 프리미엄 섹션
            premiumSection

            // MARK: - 카테고리 선호도 섹션
            categorySection

            // MARK: - 폰트 크기 섹션
            fontSizeSection

            // MARK: - 앱 정보 섹션
            infoSection
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppColor.background)
        .navigationTitle("설정")
        .sheet(isPresented: $showPremium) {
            PremiumView()
                .environmentObject(premiumService)
        }
        .task {
            viewModel.premiumService = premiumService
        }
    }

    // MARK: - 프리미엄 섹션
    private var premiumSection: some View {
        Section {
            Button {
                showPremium = true
            } label: {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(AppColor.accent)
                        .font(.title3)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(premiumService.premiumStatus.isActive ? "프리미엄 활성화됨" : "프리미엄으로 업그레이드")
                            .font(.headline)
                            .foregroundColor(AppColor.textPrimary)

                        Text(premiumService.premiumStatus.isActive ? "모든 기능을 사용 중입니다" : "광고 제거, 무제한 북마크 등")
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColor.textSecondary)
                }
            }
            .listRowBackground(AppColor.cardBackground)
        } header: {
            Text("구독")
                .foregroundColor(AppColor.textSecondary)
        }
    }

    // MARK: - 카테고리 선호도
    private var categorySection: some View {
        Section {
            ForEach(NewsCategory.allCases) { category in
                Toggle(isOn: Binding(
                    get: { viewModel.preferences.selectedCategories.contains(category) },
                    set: { _ in viewModel.toggleCategory(category) }
                )) {
                    HStack(spacing: 10) {
                        Image(systemName: category.iconName)
                            .foregroundColor(AppColor.categoryColor(for: category))
                            .frame(width: 24)
                        Text(category.displayName)
                            .foregroundColor(AppColor.textPrimary)
                    }
                }
                .tint(AppColor.primary)
                .listRowBackground(AppColor.cardBackground)
            }
        } header: {
            Text("카테고리 선호도")
                .foregroundColor(AppColor.textSecondary)
        }
    }

    // MARK: - 폰트 크기 설정
    private var fontSizeSection: some View {
        Section {
            Picker("본문 폰트 크기", selection: $viewModel.preferences.fontSize) {
                ForEach(FontSize.allCases, id: \.self) { size in
                    Text("\(size.displayName) (\(Int(size.bodySize))pt)")
                        .tag(size)
                }
            }
            .foregroundColor(AppColor.textPrimary)
            .listRowBackground(AppColor.cardBackground)
            .onChange(of: viewModel.preferences.fontSize) {
                viewModel.savePreferences()
            }
        } header: {
            Text("표시")
                .foregroundColor(AppColor.textSecondary)
        }
    }

    // MARK: - 앱 정보
    private var infoSection: some View {
        Section {
            HStack {
                Text("버전")
                    .foregroundColor(AppColor.textPrimary)
                Spacer()
                Text("1.0.0")
                    .foregroundColor(AppColor.textSecondary)
            }
            .listRowBackground(AppColor.cardBackground)

            HStack {
                Text("개발")
                    .foregroundColor(AppColor.textPrimary)
                Spacer()
                Text("Team Entangle")
                    .foregroundColor(AppColor.textSecondary)
            }
            .listRowBackground(AppColor.cardBackground)

            Link(destination: URL(string: "https://thumbscore.xyz")!) {
                HStack {
                    Text("웹사이트")
                        .foregroundColor(AppColor.textPrimary)
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(AppColor.secondary)
                }
            }
            .listRowBackground(AppColor.cardBackground)
        } header: {
            Text("정보")
                .foregroundColor(AppColor.textSecondary)
        }
    }
}
