import json
import os

def refine_translations():
    path = 'DynamicNotch/Resources/Localization/Localizable.xcstrings'
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    replacements = {
        "집중하다": "집중 모드",
        "회로망": "네트워크",
        "골짜기": "노치",
        "시간제 노동자": "타이머",
        "공중 투하": "AirDrop",
        "쟁반": "트레이",
        "물오리": "청록색",
        "생기": "애니메이션",
        "단단한": "단색",
        "원천": "소스",
        "체계": "시스템",
        "유용": "유틸리티",
        "용량": "음량",
        "모습": "화면 표시",
        "하얀색": "흰색",
        "수직의": "세로",
        "주제": "테마",
        "기준": "표준",
        "작은": "작게",
        "스트로크 폭": "테두리 두께",
        "트랙 아트웍": "앨범 커버",
        "아트웍 추적": "앨범 커버",
        "에어드롭": "AirDrop",
        "와이어가드": "WireGuard",
        "유튜브 뮤직": "YouTube Music",
        "애플 뮤직": "Apple Music",
        "스포티파이": "Spotify",
        "소리 잠금 해제": "잠금 해제 사운드",
        "VPN 외관": "VPN 디자인",
        "Wi-Fi 지속 시간": "Wi-Fi 표시 시간",
        "초점 액센트 스트로크": "집중 모드 강조 테두리",
        "액센트 스트로크": "강조 테두리",
        "노치 스트로크": "노치 테두리",
        "스트로크": "테두리",
        "화면 기록": "화면 녹화",
        "로그인 시 자동 실행": "로그인 시 시작",
        "앱 인터페이스에 사용되는 언어를 선택하세요.": "앱 인터페이스 언어를 선택합니다.",
        "레포지토리": "저장소 (Repository)",
        "머지 컨플릭트": "병합 충돌",
        "일반적인": "일반",
        "노치 룩앤필": "노치 룩앤필",
        "손쉬운 사용, 블루투스 및 미디어 제어 권한.": "접근성, 블루투스 및 미디어 제어 권한.",
        "디스플레이 위치 및 앱 언어 설정.": "시작 프로그램, 화면 위치 및 언어 설정.",
        "AirDrop 실시간 활동": "AirDrop 실시간 알림",
        "타이머 활동": "타이머 활동",
        "타이머 라이브 활동": "타이머 실시간 알림",
        "VPN 임시 활동": "VPN 알림",
        "Wi-Fi 임시 알림": "Wi-Fi 알림",
        "임시 활동": "임시 알림",
        "트레이 라이브 활동": "트레이 알림",
        "트레이 대상": "트레이 드롭 대상",
        "트레이 사용량": "트레이 사용",
        "드래그 대상": "드롭 영역",
        "액센트": "강조 색상",
        "색조": "틴트(Tint)"
    }

    # Also exact match replacements
    exact_replacements = {
        "에 대한": "정보",
        "외관": "화면 표시",
        "설정": "설정",
        "권한": "권한"
    }

    strings = data.get('strings', {})
    for key, value in strings.items():
        locs = value.get('localizations', {})
        if 'ko' in locs:
            val = locs['ko'].get('stringUnit', {}).get('value', '')
            if not val:
                continue

            new_val = val
            for old_word, new_word in replacements.items():
                new_val = new_val.replace(old_word, new_word)
                
            if val in exact_replacements:
                new_val = exact_replacements[val]
                
            locs['ko']['stringUnit']['value'] = new_val

    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print("Refined translations in Localizable.xcstrings.")

if __name__ == '__main__':
    refine_translations()
