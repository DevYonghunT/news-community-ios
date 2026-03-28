import SwiftUI

// MARK: - 카테고리 배지 뷰
/// 카테고리 아이콘과 이름을 작은 배지로 표시
struct CategoryBadgeView: View {
    /// 표시할 카테고리
    let category: NewsCategory

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.iconName)
                .font(.caption2)

            Text(category.displayName)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(AppColor.categoryColor(for: category).opacity(0.2))
        .foregroundColor(AppColor.categoryColor(for: category))
        .cornerRadius(6)
    }
}
