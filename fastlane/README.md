# Fastlane 설정 가이드

## 초기 설정

### 1. Appfile 설정
`fastlane/Appfile` 파일을 열고 다음 정보를 입력하세요:
- `apple_id`: Apple Developer 계정 이메일
- `team_id`: Apple Developer Team ID (선택사항)

### 2. Match 설정 (인증서 관리)
인증서와 프로비저닝 프로파일을 관리하기 위해 match를 사용하는 것을 권장합니다.

```bash
# 처음 한 번만 실행
bundle exec fastlane match development
bundle exec fastlane match appstore
```

> **참고**: Match는 별도의 Git 저장소가 필요합니다. 기존 저장소나 새로운 private 저장소를 사용할 수 있습니다.

### 3. Gemfile 설치
```bash
bundle install
```

## 사용 가능한 Lane

### 기본 작업
- `fastlane generate_project`: Tuist 프로젝트 생성
- `fastlane test`: 테스트 실행
- `fastlane build`: 개발 빌드

### 배포 관련
- `fastlane beta`: App Store용 아카이브 생성
- `fastlane beta_upload`: TestFlight에 업로드
- `fastlane release`: App Store에 배포

### 유틸리티
- `fastlane increment_build`: 빌드 번호 증가
- `fastlane increment_version`: 버전 및 빌드 번호 증가

## 사용 예시

```bash
# bundle을 사용하는 경우
bundle exec fastlane test
bundle exec fastlane beta

# 또는 bundle 없이 직접 실행 (전역 설치된 경우)
fastlane test
fastlane beta
```

## 참고 자료
- [Fastlane 공식 문서](https://docs.fastlane.tools/)
- [Match 가이드](https://docs.fastlane.tools/actions/match/)