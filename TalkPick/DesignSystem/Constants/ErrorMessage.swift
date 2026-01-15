import Foundation

struct ErrorMessage {
    private static let retrySuffix = "\n다시 시도해주세요."
    
    // 로그인 관련
    static let loginFailed = "로그인에 실패했습니다." + retrySuffix
    static let appleLoginFailed = "애플 로그인에 실패했습니다." + retrySuffix
    static let loginInfoFailed = "로그인 정보를 가져오는데 실패했습니다." + retrySuffix
    
    // 약관/회원가입 관련
    static let termAgreementFailed = "약관 동의에 실패했습니다." + retrySuffix
    static let signUpFailed = "회원가입에 실패했습니다." + retrySuffix
    
    // 프로필 관련
    static let profileLoadFailed = "프로필 불러오기에 실패했습니다." + retrySuffix
    static let profileEditFailed = "프로필 수정에 실패했습니다." + retrySuffix
    static let accountDeleteFailed = "회원 탈퇴에 실패했습니다." + retrySuffix
    static let logoutFailed = "로그아웃에 실패했습니다." + retrySuffix
    
    // 토픽 관련
    static let topicLikeFailed = "좋아요에 실패했습니다." + retrySuffix
    static let topicDetailLoadFailed = "토픽 상세 불러오기에 실패했습니다." + retrySuffix
    static let todayTopicLoadFailed = "오늘의 토픽 불러오기에 실패했습니다." + retrySuffix
    static let categoryLoadFailed = "카테고리 불러오기에 실패했습니다." + retrySuffix
    static let likedTopicLoadFailed = "좋아요한 토픽 불러오기에 실패했습니다." + retrySuffix
    
    // 랜덤 대화 관련
    static let randomStartFailed = "랜덤 대화 시작하기에 실패했습니다." + retrySuffix
    static let randomTopicLoadFailed = "랜덤 대화 토픽 불러오기에 실패했습니다." + retrySuffix
    static let randomRateFailed = "평점 남기기에 실패했습니다." + retrySuffix
    static let randomQuitFailed = "랜덤 대화 나가기에 실패했습니다." + retrySuffix
    static let randomEndFailed = "랜덤 대화 종료에 실패했습니다." + retrySuffix
    static let randomCommentFailed = "한줄평 남기기에 실패했습니다." + retrySuffix
    static let randomTotalRecordFailed = "기록 저장에 실패했습니다." + retrySuffix
}
