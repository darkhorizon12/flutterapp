# actual

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Android Studio 설정 시 주의사항
* flutter, dart-sdk 패스 설정 시 bin 폴더까지 설정하면 안됨.
* 예) C:\tools\dart-sdk\bin 일 경우 C:\tools\dart-sdk 까지 설정해야 함.

### 외부폴더 (img, fonts) 설정 후
* pubspec.yaml의 assets, fonts에 등록
* flutter pub get 명령어 실행

### Widget
* SingleChildScrollView
    * 화면의 크기가 부족해서 덮어쓰는 현상이 발생할 때 Scroll 효과
    * keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual/onDrag
* SafeArea
    : 
* MaterailApp
* IntrinsicHeight
    * 같은 레벨의 위젯이라도 각기 차지하는 영역이 다름. 따라서 최대 영역의 위젯과 맞추기 위해서는 부모 위젯을 이 위젯으로 감싸면 동일하게 변경

### StateWidget
* initState: 비동기가 안됨. 그래서 비동기 함수를 선언한 다음 initState에서 호출해서 사용해야 함.

### Token vs Session
* 차이: Session은 데이터베이스에 저장, Token은 Signature를 통해 검증하기 때문에 데이터베이스에 저장하지 않음
* Token은 정보가 모두 담겨있기 때문에 정보유출의 위험이 있음. 따라서 토큰에 중요한 정보를 담으면 안됨

### JWT (Json Web Token)
* Header + Payload + Signature
* Base64 Encoding (Binary To Text)
* Header: 토큰의 종류, 암호화 알고리즘 등 토큰에 대한 정보
* Payload: 발행일, 만료일, 사용자 ID 등 사용자 검증에 대한 정보
* Signature: Header, Payload를 Base64로 인코딩해서 알고리즘으로 싸인한 값. 조작여부 판단


### Dio

### flutter secure storage

### JSON_SERIALIZABLE
* @JsonSerializable() 어노테이션 추가 후 flutter pub run build_runner build/watch 로 재빌드
* 시리얼화된 모델 내부변수에 모델이 있을 경우, 마찬가지로 @JsonSerializable 어노테이션 추가해야 함

* .g파일 원본파일 하위로 보내고 싶을 때 
  * 톱니바퀴(Show options menu) > File Nesting > 맨 끝에 .g.dart; 추가 후 OK

### REtrofit

### 상태
```agsl
dependencies:
  flutter_riverpod: ^2.1.3
  riverpod_annotation: ^1.1.1
  
  
dev_dependencies:
  riverpod_generator: ^1.1.1  
```

### 심화 로딩 skeletons: mimic the page's layout while loading.
