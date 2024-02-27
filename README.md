
# 👨‍👩‍👦‍👦 PlaMeet 👨‍👩‍👦‍👦 
> PlaMeet 서로의 시간을 소중하게 여기게 해주는 약속앱! 👉 https://apps.apple.com/kr/app/plameet/id6473112707

![](https://github.com/PromiseApp/iOS/assets/99011004/0b31bba0-5d92-4d0c-9cbc-232ca11f64b4)

## 📖 Description
PlaMeet은 단순한 약속 잡기를 넘어서, 서로의 시간을 소중히 여기고 약속을 지키는 것을 더욱 재미있고 의미 있게 만들어주는 모바일 앱입니다. 

친구들과의 만남부터 비즈니스 미팅까지, 모든 약속을 한 곳에서 관리하고, 각각의 약속을 성공적으로 이행할 때마다 레벨이 올라가는 독특한 경험을 제공합니다. 

기록된 벌칙과 레벨 기능을 통해 약속을 지키고자 하는 동기를 부여합니다.

## 👨‍👩‍👧‍👦 Developer
* iOS 1명, Back-End 1명, 디자이너 1명  

## 🔧 기술 스택
### 패키지 관리
- Swift Package Manager
- CocoaPods

### 데이터베이스
- Realm Swift

### 디자인 도구
- Figma

### 푸시 알림
- Apple Push Notification service (APNs)

### 버전 관리
- Git

### CI/CD
- Fastlane

### 네트워킹
- 소켓통신 (Stomp)
- Moya/RxMoya (RestAPI)

### UI 개발
- UIKit
- SnapKit
- Then

### 반응형 프로그래밍
- RxSwift
- RxDataSources
- RxFlow

### 아키텍처 패턴
- MVVM-C

### 이미지 로딩 라이브러리
- Kingfisher


## ⭐ Main Feature
### 회원가입 및 로그인 
<img src="https://github.com/PromiseApp/iOS/assets/99011004/d18f225a-f0d0-47c4-846e-a8a9319ed372" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/8a1287af-93f8-4206-af02-0697391e410e" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/31a3c3cc-c6f9-4890-8fd7-b5fe18f8126a" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/cab2b936-cf30-4128-b88c-2b9f2b0e3e73" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/6bc437f7-dc63-462f-a997-08772ef19c34" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/3fba960a-d0b2-42cb-b56a-3477d88b45a2" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/bd588a44-f513-4905-a540-76e7992a7da7" width="200">

- 이메일 인증, JWT 토큰 활용

### 알림
<img src="https://github.com/PromiseApp/iOS/assets/99011004/e6f26de0-fa91-4320-a8a4-abc6da287deb" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/4781d6bb-725d-4cc1-b769-5757703ebd98" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/9b486bc3-55f6-488a-a0ac-6c711a609bd0" width="200">

- 새로운 약속, 친구 요청, 채팅에 대한 알림 제공
- 각 알림을 누르면 해당되는 페이지로 이동

### 약속 생성
<img src="https://github.com/PromiseApp/iOS/assets/99011004/9fbc191e-4068-4e79-9810-8ac69b2747ba" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/d8c62613-f000-47cc-8253-d3c7072317e7" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/570d8ba6-68c9-4308-9c45-6483b58a0684" width="200">

- 제목, 일정, 친구 -> 필수
- 장소, 벌칙, 메모 -> 선택

### 새로운 약속 목록
<img src="https://github.com/PromiseApp/iOS/assets/99011004/0fc211f5-25cc-471c-85b8-cb6d09c289e5" width="200">

- 새로운 약속에 대해 불참, 참여 선택

### 약속 결과 선택
<img src="https://github.com/PromiseApp/iOS/assets/99011004/530a6dbe-4792-4dc0-8c35-df84db358911" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/58d81163-6b02-45ad-afff-6b916d2911ad" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/f69098cd-4b5d-48fe-a064-0f51baf4ee2d" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/704d8c58-3549-49a8-a510-16c2b90446b5" width="200">

- 결과 선택은 방장 권한으로 결과를 선택하면 성공 시 경험치 1 증가, 실패 시 경험치 증가 없음

### 지난 약속 목록
<img src="https://github.com/PromiseApp/iOS/assets/99011004/dc29334d-f4f9-42d8-9af8-e09ea736366c" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/c9351654-f4c1-407d-a912-2f239251b6dc" width="200">

- 지난 약속에 대한 목록이 월별로 표시되며 제목을 검색하면 해당 제목의 약속 목록 표시
- 파일 모양 버튼 클릭 시 상세 페이지로 이동

### 채팅방 목록
<img src="https://github.com/PromiseApp/iOS/assets/99011004/883ae2e0-8272-4df2-b964-c783c20078bb" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/d8403eb2-740f-4fb7-813f-07ac9cfd4337" width="200">

- 약속 생성과 동시에 채팅방 생성
- 채팅이 오면 채팅 횟수만큼 표시

### 채팅방
<img src="https://github.com/PromiseApp/iOS/assets/99011004/521141ac-9749-478e-9740-9958ebec0f34" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/4cc1a123-3c53-4a96-a1d7-0ec1050b5861" width="200">

- 채팅방에 들어가자마자 가장 최신 채팅이 보이게 개발

### 친구 목록
<img src="https://github.com/PromiseApp/iOS/assets/99011004/181742e9-24ad-47b8-85a9-97f25ca47059" width="200">

- 친구 목록 표시

### 친구 추가 및 친구 요청 목록
<img src="https://github.com/PromiseApp/iOS/assets/99011004/5133a28c-2da9-48cf-8ad0-2c6248303e8b" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/280beb95-0363-40c8-9e61-763ec24d0d78" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/92e69f5a-3403-4212-b328-ff98347a1ff9" width="200">

- 친구 추가 및 친구 요청 목록 조회

### 마이 페이지
<img src="https://github.com/PromiseApp/iOS/assets/99011004/07934d5c-d557-4514-bbb4-1fe058b800e1" width="200">
<img src="https://github.com/PromiseApp/iOS/assets/99011004/d1be60ac-8f99-4fd1-9b55-8b4b91e959a7" width="200">
<img src="[https://github.com/PromiseApp/iOS/assets/99011004/92e69f5a-3403-4212-b328-ff98347a1ff9](https://github.com/PromiseApp/iOS/assets/99011004/bab24537-d594-49bf-9cbe-c753ddf7b748)" width="200">

- 프로필 표시
- 레벨업까지 남은 경험치 안내
- 공지사항 및 문의 기능 제공
- 프로필 수정
- 등등

