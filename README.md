# 📚 TalkPick

![iOS](https://img.shields.io/badge/-IOS-black?logo=apple)

TalkPick은 상황에 맞는 질문을 추천하여 대화를 시작하도록 돕는 애플리케이션입니다.

---

## ⚡️ 주요 기술 스택

- **UIKit**: iOS 앱의 화면과 UI를 구성하는 기본 프레임워크
- **Tuist**: iOS 프로젝트 구조를 모듈화하고 관리하는 도구
- **Alamofire**: 네트워크 통신을 간편하게 처리하는 라이브러리
- **Kingfisher**: 이미지 다운로드 및 캐싱을 지원하는 라이브러리
- **RxSwift**: 비동기 이벤트와 데이터 흐름을 반응형으로 처리하는 라이브러리
- **Snapkit**: Auto Layout을 코드로 간결하게 작성할 수 있게 도와주는 라이브러리
- **KakaoSDK**: 카카오 로그인 연동을 위한 SDK

---

## 🗂️ 프로젝트 폴더 구조

```
Resources/
├── Assets
└── Info.plist
Sources/
├── AppDelegate
└── SceneDelegate
Data/
├── APIs
├── Extensions
└── Repositories
Data/
├── Entities
└── UseCases
DesignSystem/
├── Components
└── Extensions
Presentation/
├── Cell
├── ViewController
└── ViewModel
```

---

## 🏗️ 레이어 구조 및 설계 원칙

- **Presentation Layer**: 화면 단위의 ViewController와 비즈니스 로직을 연결하는 ViewModel
- **DesignSystem Layer**: 재사용 가능한 UI 컴포넌트
- **Domain Layer**: 핵심 비즈니스 로직 및 UseCase
- **Data Layer**: 데이터 소스 관리 (Repository, API, Local Storage)

---

## 🚀 시작하기 (Getting Started)

### 1️⃣ Tuist 설치 여부 확인
```
tuist version
```
버전이 나오면 → 이미 설치됨 ✅

안 나오면 → 설치 필요 ⬇️
```
curl -Ls https://install.tuist.io | bash
```

설치 후
```
export PATH="$HOME/.tuist/bin:$PATH"
```
<br>

### 2️⃣ GitHub 프로젝트 클론
#### git clone <깃허브_레포_URL>
#### cd <프로젝트_폴더>
<br>

### 3️⃣ Tuist 버전 맞추기 (중요 ⚠️)
```
tuist install
```
👉 프로젝트에서 사용하는 Tuist 버전과 동일하게 맞춰줌
<br>

### 4️⃣ 의존성 준비
🔹 Tuist 캐시 / 의존성 설치
```
tuist fetch
```
(또는)
```
tuist dependencies fetch
```
<br>

### 5️⃣ 프로젝트 생성
```
tuist generate
```
또는 워크스페이스까지 포함:
```
tuist generate --no-open
```
<br>

### 6️⃣ Xcode에서 실행
#### 생성된 파일 중 하나 열기:
#### *.xcworkspace (대부분 이거)
#### 또는 *.xcodeproj
#### ▶️ 시뮬레이터 선택 후 Run 하면 끝 🎉

---
- 궁금한 점은 이슈로 남겨주세요.
