import Foundation

// MARK: - 뉴스 서비스 프로토콜
protocol NewsServiceProtocol {
    /// 카테고리별 기사 목록 조회
    func fetchArticles(category: NewsCategory?) async throws -> [NewsArticle]
    /// 트렌딩 기사 조회
    func fetchTrending() async throws -> [NewsArticle]
}

// MARK: - 뉴스 서비스 에러
enum NewsServiceError: LocalizedError {
    case networkError
    case decodingError
    case serverError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "네트워크 연결에 실패했습니다."
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다."
        case .serverError(let code):
            return "서버 오류가 발생했습니다. (코드: \(code))"
        }
    }
}

// MARK: - Mock 뉴스 서비스
final class MockNewsService: NewsServiceProtocol {
    /// 싱글톤 인스턴스
    static let shared = MockNewsService()

    init() {}

    /// 카테고리별 기사 조회 (시뮬레이션)
    func fetchArticles(category: NewsCategory?) async throws -> [NewsArticle] {
        // 네트워크 지연 시뮬레이션 (0.5~1.5초)
        let delay = Double.random(in: 0.5...1.5)
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

        let allArticles = Self.buildMockArticles()

        if let category = category {
            return allArticles.filter { $0.category == category }
        }
        return allArticles
    }

    /// 트렌딩 기사 조회 (좋아요 순)
    func fetchTrending() async throws -> [NewsArticle] {
        let delay = Double.random(in: 0.5...1.5)
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

        let allArticles = Self.buildMockArticles()
        return allArticles.sorted { $0.likeCount > $1.likeCount }
    }

    // MARK: - Mock 데이터 생성

    /// 사전 구축된 현실적 한국어 뉴스 기사 풀
    private static func buildMockArticles() -> [NewsArticle] {
        let now = Date()

        return [
            // 기술
            NewsArticle(
                title: "애플, iOS 20에서 AI 비서 대폭 강화…시리 완전 교체 가능성",
                summary: "애플이 차세대 iOS에서 시리를 대규모로 개편하고 생성형 AI 기능을 전면 도입할 계획인 것으로 알려졌다.",
                content: "애플이 올해 WWDC에서 iOS 20을 발표하며 AI 비서 기능을 대폭 강화할 전망이다. 블룸버그에 따르면 시리의 대화 능력이 크게 향상되고, 앱 간 연동 기능이 추가된다. 특히 메일 요약, 사진 편집, 코드 생성 등 다양한 분야에서 AI 활용이 확대될 것으로 보인다. 업계 관계자는 \"이번 업데이트가 애플 AI 전략의 전환점이 될 것\"이라고 분석했다.",
                source: "테크조선",
                author: "김기자",
                imageURL: nil,
                category: .technology,
                publishedAt: now.addingTimeInterval(-3600),
                likeCount: 342,
                commentCount: 87
            ),
            NewsArticle(
                title: "삼성전자, 3나노 GAA 공정 양산 본격화…파운드리 점유율 확대",
                summary: "삼성전자가 3세대 3나노 GAA 공정의 안정적 양산에 성공하며 TSMC와의 격차를 줄이고 있다.",
                content: "삼성전자 파운드리 사업부가 3나노 GAA(Gate-All-Around) 공정 3세대 양산에 돌입했다. 수율이 크게 개선되면서 주요 팹리스 업체들의 주문이 증가하고 있는 것으로 알려졌다. 삼성전자는 이를 통해 TSMC 대비 기술 격차를 1년 이내로 줄일 수 있을 것으로 전망하고 있다.",
                source: "전자신문",
                author: "박기자",
                imageURL: nil,
                category: .technology,
                publishedAt: now.addingTimeInterval(-7200),
                likeCount: 218,
                commentCount: 45
            ),
            NewsArticle(
                title: "네이버, 초거대 AI '하이퍼클로바X' 기업용 서비스 글로벌 출시",
                summary: "네이버가 자체 개발 AI 모델 하이퍼클로바X를 기반으로 한 B2B 서비스를 해외 시장에 본격 진출한다.",
                content: "네이버가 하이퍼클로바X 기반의 기업용 AI 솔루션을 일본, 동남아, 유럽 시장에 동시 출시한다. 문서 요약, 고객 응대, 데이터 분석 등의 기능을 제공하며, 다국어 지원이 강점이다. 네이버 관계자는 \"한국어와 일본어에서 GPT-4 수준의 성능을 달성했다\"고 밝혔다.",
                source: "한경비즈",
                author: "이기자",
                imageURL: nil,
                category: .technology,
                publishedAt: now.addingTimeInterval(-14400),
                likeCount: 156,
                commentCount: 32
            ),

            // 경제
            NewsArticle(
                title: "한국은행, 기준금리 0.25%p 인하…경기 부양 의지 표명",
                summary: "한국은행 금융통화위원회가 기준금리를 0.25%p 인하하며 경기 부양에 나섰다.",
                content: "한국은행 금융통화위원회는 오늘 기준금리를 연 2.50%로 0.25%p 인하했다. 이창용 총재는 \"내수 부진과 수출 둔화에 대응하기 위한 선제적 조치\"라고 설명했다. 시장에서는 추가 인하 가능성에 주목하고 있으며, 원·달러 환율은 소폭 상승했다.",
                source: "매일경제",
                author: "최기자",
                imageURL: nil,
                category: .business,
                publishedAt: now.addingTimeInterval(-5400),
                likeCount: 567,
                commentCount: 234
            ),
            NewsArticle(
                title: "코스피, 외국인 매수세에 2,800선 돌파…반도체주 강세",
                summary: "외국인 투자자들의 대규모 매수세가 유입되며 코스피가 2,800포인트를 넘어섰다.",
                content: "코스피 지수가 외국인의 집중 매수에 힘입어 장중 2,823.45포인트를 기록했다. 삼성전자, SK하이닉스 등 반도체 관련주가 3% 이상 급등하며 지수 상승을 이끌었다. 전문가들은 \"글로벌 AI 투자 확대가 한국 반도체 업종에 긍정적\"이라고 분석했다.",
                source: "한국경제",
                author: "정기자",
                imageURL: nil,
                category: .business,
                publishedAt: now.addingTimeInterval(-10800),
                likeCount: 423,
                commentCount: 156
            ),

            // 연예
            NewsArticle(
                title: "BTS 진, 솔로 월드투어 발표…30개국 50개 도시 순회 공연",
                summary: "BTS 멤버 진이 첫 솔로 월드투어를 발표하며 전 세계 팬들의 뜨거운 반응을 얻고 있다.",
                content: "BTS 진이 첫 솔로 월드투어 'The Astronaut World Tour'를 발표했다. 4월 서울을 시작으로 30개국 50개 도시를 순회하며, 1차 티켓 예매는 오픈 30초 만에 전석 매진됐다. 빅히트뮤직 측은 \"압도적인 수요에 추가 공연을 검토 중\"이라고 밝혔다.",
                source: "스포츠동아",
                author: "한기자",
                imageURL: nil,
                category: .entertainment,
                publishedAt: now.addingTimeInterval(-1800),
                likeCount: 1892,
                commentCount: 743
            ),
            NewsArticle(
                title: "넷플릭스 한국 오리지널 '지옥행 열차', 글로벌 1위 달성",
                summary: "넷플릭스의 새 한국 시리즈가 공개 3일 만에 비영어권 TV 부문 글로벌 1위에 올랐다.",
                content: "넷플릭스 한국 오리지널 시리즈 '지옥행 열차'가 공개 3일 만에 비영어권 TV 부문 글로벌 1위를 차지했다. 첫 주 조회수 8,500만 시간을 기록하며 역대 한국 시리즈 최고 성적을 세웠다. 봉준호 감독이 총괄 프로듀서를 맡아 화제가 됐으며, 시즌 2 제작이 조기 확정됐다.",
                source: "엔터미디어",
                author: "송기자",
                imageURL: nil,
                category: .entertainment,
                publishedAt: now.addingTimeInterval(-21600),
                likeCount: 934,
                commentCount: 312
            ),

            // 스포츠
            NewsArticle(
                title: "손흥민, 프리미어리그 시즌 20호골…아시아 선수 새 역사",
                summary: "토트넘 손흥민이 프리미어리그 단일 시즌 20골을 달성하며 아시아 선수 최다 기록을 경신했다.",
                content: "손흥민이 맨시티전에서 멀티골을 기록하며 프리미어리그 시즌 20호골을 달성했다. 이는 아시아 선수 단일 시즌 최다 득점 기록이다. 앙헤 포스테코글루 감독은 \"손흥민은 세계 최고 수준의 공격수\"라며 극찬했다.",
                source: "스포츠조선",
                author: "문기자",
                imageURL: nil,
                category: .sports,
                publishedAt: now.addingTimeInterval(-9000),
                likeCount: 2134,
                commentCount: 567
            ),
            NewsArticle(
                title: "KBO 개막전 역대 최다 관중…야구 열풍 이어간다",
                summary: "2026 KBO 프로야구 개막전에 역대 최다 관중이 몰리며 한국 야구의 인기를 실감케 했다.",
                content: "2026 KBO 프로야구 시즌이 역대 최다 개막전 관중 기록과 함께 시작됐다. 전국 5개 구장에서 총 13만 2천 명의 관중이 운집했으며, 이는 기존 기록을 1만 5천 명 넘어선 것이다. KBO 관계자는 \"팬 서비스 강화와 선수들의 활약이 시너지를 만들고 있다\"고 분석했다.",
                source: "일간스포츠",
                author: "윤기자",
                imageURL: nil,
                category: .sports,
                publishedAt: now.addingTimeInterval(-43200),
                likeCount: 876,
                commentCount: 234
            ),

            // 건강
            NewsArticle(
                title: "서울대병원 연구팀, AI 기반 암 조기진단 기술 개발 성공",
                summary: "서울대병원 연구팀이 혈액 검사만으로 6종 암을 조기에 진단할 수 있는 AI 시스템을 개발했다.",
                content: "서울대병원 연구팀이 혈액 내 마이크로RNA 패턴을 AI로 분석해 위암, 폐암, 간암, 대장암, 유방암, 췌장암 6종을 1기 단계에서 93% 정확도로 진단하는 기술을 개발했다. 이 연구는 네이처 메디신에 게재됐으며, 내년 임상 시험 돌입 예정이다.",
                source: "메디칼투데이",
                author: "강기자",
                imageURL: nil,
                category: .health,
                publishedAt: now.addingTimeInterval(-28800),
                likeCount: 1245,
                commentCount: 89
            ),
            NewsArticle(
                title: "수면 부족이 치매 위험 40% 높인다…대규모 연구 결과 발표",
                summary: "하루 6시간 미만 수면이 알츠하이머 치매 발생 위험을 40% 높인다는 대규모 추적 연구 결과가 나왔다.",
                content: "고려대 의대 연구팀이 50만 명을 10년간 추적한 결과, 하루 6시간 미만 수면 그룹의 치매 발생률이 7시간 이상 수면 그룹 대비 40% 높은 것으로 나타났다. 연구팀은 \"수면 중 뇌의 노폐물 제거 기능이 저하되면서 아밀로이드 베타 축적이 가속화된다\"고 설명했다.",
                source: "헬스경향",
                author: "오기자",
                imageURL: nil,
                category: .health,
                publishedAt: now.addingTimeInterval(-36000),
                likeCount: 567,
                commentCount: 123
            ),

            // 과학
            NewsArticle(
                title: "KAIST, 상온 초전도체 후보 물질 새로운 합성 경로 발견",
                summary: "KAIST 연구팀이 상온 초전도체 후보 물질의 새로운 합성 방법을 발견해 국제 학계의 주목을 받고 있다.",
                content: "KAIST 물리학과 연구팀이 구리-질소 기반 화합물에서 상온 초전도 가능성을 보이는 새로운 합성 경로를 발견했다. 해당 물질은 영하 30도에서 초전도 현상을 보였으며, 이는 기존 기록 대비 획기적으로 높은 온도다. 사이언스지에 게재된 이 연구는 독립적 검증이 진행 중이다.",
                source: "사이언스타임즈",
                author: "조기자",
                imageURL: nil,
                category: .science,
                publishedAt: now.addingTimeInterval(-50400),
                likeCount: 2345,
                commentCount: 456
            ),
            NewsArticle(
                title: "화성 탐사 로버 '아리랑', 물 흔적 포함 암석 시료 채취 성공",
                summary: "한국 최초 화성 탐사 로버가 물 존재 흔적이 포함된 암석 시료를 채취하는 데 성공했다.",
                content: "한국항공우주연구원(KARI)의 화성 탐사 로버 '아리랑'이 화성 예제로 분화구에서 수분 함유 광물이 포함된 암석 시료 채취에 성공했다. 이 시료는 과거 화성에 액체 상태의 물이 존재했음을 시사하며, 향후 지구 귀환 미션에서 회수될 예정이다.",
                source: "과학동아",
                author: "임기자",
                imageURL: nil,
                category: .science,
                publishedAt: now.addingTimeInterval(-64800),
                likeCount: 1876,
                commentCount: 321
            ),

            // 정치
            NewsArticle(
                title: "여야, 반도체 특별법 합의…세액공제 확대 핵심",
                summary: "여야가 반도체 산업 지원을 위한 특별법에 합의하며 세액공제 비율을 대폭 확대하기로 했다.",
                content: "여야가 '반도체 산업 경쟁력 강화 특별법'에 전격 합의했다. 핵심은 반도체 설비 투자 세액공제 비율을 대기업 25%, 중소기업 35%로 확대하는 것이다. 또한 반도체 인력 양성을 위해 대학 정원 확대와 장학금 제도 신설도 포함됐다.",
                source: "뉴시스",
                author: "배기자",
                imageURL: nil,
                category: .politics,
                publishedAt: now.addingTimeInterval(-18000),
                likeCount: 312,
                commentCount: 567
            ),
            NewsArticle(
                title: "국회, 디지털 자산 기본법 본회의 통과…제도권 편입 확정",
                summary: "가상자산을 제도권으로 편입시키는 디지털 자산 기본법이 국회 본회의를 통과했다.",
                content: "국회 본회의에서 '디지털 자산 기본법'이 찬성 231표, 반대 42표, 기권 15표로 통과됐다. 이 법안은 가상자산 거래소 등록제, 투자자 보호 기금 설치, 스테이블코인 발행 기준 등을 담고 있다. 법 시행은 공포 후 6개월 뒤부터 적용된다.",
                source: "연합뉴스",
                author: "서기자",
                imageURL: nil,
                category: .politics,
                publishedAt: now.addingTimeInterval(-72000),
                likeCount: 678,
                commentCount: 890
            ),

            // 세계
            NewsArticle(
                title: "EU, AI 규제법 전면 시행…빅테크 기업 대규모 벌금 가능",
                summary: "유럽연합의 AI 규제법이 전면 시행되며 위반 기업에 전세계 매출 7%의 벌금이 부과될 수 있다.",
                content: "EU AI Act가 오늘부터 전면 시행에 들어갔다. 고위험 AI 시스템은 사전 인증을 받아야 하며, 생성형 AI 서비스는 학습 데이터 출처를 공개해야 한다. 위반 시 전 세계 매출의 최대 7%에 달하는 벌금이 부과된다. 구글, 메타, 오픈AI 등 주요 기업들은 규정 준수를 위한 팀을 신설한 것으로 알려졌다.",
                source: "글로벌이코노믹",
                author: "황기자",
                imageURL: nil,
                category: .world,
                publishedAt: now.addingTimeInterval(-25200),
                likeCount: 456,
                commentCount: 178
            ),
            NewsArticle(
                title: "일본, 역대 최대 규모 경제 부양책 발표…150조 엔 투입",
                summary: "일본 정부가 경기 침체 대응을 위해 역대 최대 규모인 150조 엔의 경제 부양책을 발표했다.",
                content: "일본 정부가 역대 최대 규모인 150조 엔(약 1,350조 원)의 경제 부양책을 발표했다. 반도체·AI 산업 지원, 중소기업 디지털 전환, 에너지 보조금 연장 등이 포함됐다. 기시다 총리는 \"일본 경제의 구조적 전환을 위한 결정적 투자\"라고 강조했다.",
                source: "NHK코리아",
                author: "나기자",
                imageURL: nil,
                category: .world,
                publishedAt: now.addingTimeInterval(-57600),
                likeCount: 234,
                commentCount: 98
            ),
            NewsArticle(
                title: "테슬라, 완전자율주행 택시 서비스 미국 5개 도시에서 개시",
                summary: "테슬라가 운전자 없는 완전자율주행 택시 서비스를 미국 주요 5개 도시에서 동시 출시했다.",
                content: "테슬라가 완전자율주행(FSD) 기반 로보택시 서비스 'Tesla Ride'를 LA, 마이애미, 오스틴, 피닉스, 라스베이거스 5개 도시에서 동시 개시했다. 별도 운전자 없이 운행되며, 우버 대비 40% 저렴한 요금을 책정했다. 일론 머스크 CEO는 \"교통의 미래가 시작됐다\"고 밝혔다.",
                source: "IT월드",
                author: "장기자",
                imageURL: nil,
                category: .technology,
                publishedAt: now.addingTimeInterval(-82800),
                likeCount: 1567,
                commentCount: 432
            ),
            NewsArticle(
                title: "국내 스타트업 '뉴로링크', 뇌-컴퓨터 인터페이스 FDA 승인 획득",
                summary: "한국 스타트업 뉴로링크가 비침습적 뇌-컴퓨터 인터페이스 장치로 FDA 승인을 받았다.",
                content: "한국 스타트업 뉴로링크가 비침습적 뇌-컴퓨터 인터페이스(BCI) 장치 'MindBridge'로 미국 FDA 승인을 획득했다. 이 장치는 두피에 부착하는 센서로 뇌파를 읽어 마비 환자가 컴퓨터와 스마트폰을 제어할 수 있게 해준다. 전 세계적으로 비침습적 BCI 장치의 FDA 승인은 세 번째다.",
                source: "바이오스펙테이터",
                author: "유기자",
                imageURL: nil,
                category: .science,
                publishedAt: now.addingTimeInterval(-39600),
                likeCount: 1123,
                commentCount: 267
            ),
            NewsArticle(
                title: "프로야구 올스타 이정후, MLB 올스타전 선발 출전 확정",
                summary: "LA 다저스 이정후가 MLB 올스타전 내셔널리그 선발 외야수로 선정됐다.",
                content: "LA 다저스 이정후가 팬 투표에서 내셔널리그 외야수 부문 1위를 차지하며 MLB 올스타전 선발 출전이 확정됐다. 시즌 타율 .328, 15홈런, 62타점을 기록 중인 이정후는 한국인 최초 올스타전 선발이라는 역사를 썼다. 이정후는 \"한국 야구팬들에게 보답하겠다\"고 소감을 밝혔다.",
                source: "MBC스포츠",
                author: "권기자",
                imageURL: nil,
                category: .sports,
                publishedAt: now.addingTimeInterval(-46800),
                likeCount: 3421,
                commentCount: 876
            ),
        ]
    }
}
