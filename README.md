utime (fork)
============

[billdami/utime](https://github.com/billdami/utime)를 fork하여 사내 필요 기능을 추가한 버전입니다.

## 추가/변경된 기능

### Transaction ID(T-ID) 변환
- 16진수 형식의 Transaction ID(`{hex}-{hex}`)를 입력하면 날짜로 변환

### 밀리초 포함 출력 옵션
- 날짜 출력 포맷에 `YYYY-MM-DDThh:mm:ss.SSS` (ISO 8601 + 밀리초) 옵션 추가

### 기타 개선
- 입력값 앞뒤 공백 자동 trim 처리
- 컨텍스트 메뉴 중복 생성 오류 수정 (`onInstalled` 이벤트로 이동)

---

원본: [billdami/utime](https://github.com/billdami/utime) — A Google Chrome extension that converts UNIX timestamps to dates (and vice versa)
