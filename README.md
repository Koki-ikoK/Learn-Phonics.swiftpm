<p align="center">
  <img src="https://github.com/user-attachments/assets/9b579dce-236d-4275-9371-0ee64d0bc956" width="31%" alt="シミュレータ画面1">
  <img src="https://github.com/user-attachments/assets/c1e16446-2c87-429e-9cbd-7dc3416ab5a6" width="31%" alt="シミュレータ画面2" style="margin-left: 8px; margin-right: 8px;">
  <img src="https://github.com/user-attachments/assets/abbcdd64-ba43-46a2-93f4-121094e69b43" width="31%" alt="シミュレータ画面3">
</p>
# Learn Phonics 🗣️
### ~ AI-Powered Real-Time Pronunciation Learning App ~

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/badge/Platform-iPadOS%20%7C%20macOS-blue.svg)]()

英語の正しい発音の基礎となる「フォニックス（音と文字の規則性）」を、独自のAI音声解析モデルを用いてインタラクティブに学べるiPad/Mac向けアプリケーションです。

---

- **Apple Swift Student Challenge 2026**: 応募作品

---

## 💡 開発背景（プロダクトへの情熱）
自身のTOEIC 800点獲得に向けた学習の中で、「単語のスペルと音の規則性（フォニックス）」の理解こそがリスニング・スピーキング向上の最短ルートであると確信したことが出発点です。

また、アメリカへ渡航した際、現地の友人に「なぜ日本ではフォニックスを重視しないのか？」と驚かれたこと、そして現地の子供たちと自身の発音が噛み合わずスムーズな会話が成立しなかったという、**強烈な悔しさ**がプロダクトの原動力となっています。
日本の英語教育にありがちな「カタカナ英語」の壁を、テクノロジーの力で楽しく壊せるツールを目指して開発しました。

---

## ✨ 主な機能
### 1. 🤖 オンデバイスAIによるリアルタイム発音判定
`Create ML` を用いて自作した音声分類モデルと `SoundAnalysis` フレームワークを統合。ユーザーが発音した音声を完全オンデバイス・低レイテンシで解析し、日本人が特につまずきやすい「L/R」や「母音（æ, ʌなど）」の正確さをリアルタイムでフィードバックします。

### 2. 🔊 ネイティブサウンド・ガイド
`AVFoundation`（`AVAudioEngine` / `AVSpeechSynthesizer`）を活用し、視覚的な口の形のアドバイスと共に、ネイティブ基準の正確なお手本音声をその場で確認・再生できます。

### 3. 🎮 ゲーミフィケーションを取り入れたインタラクティブ・クイズ
提示されたフォニックスの「音」を聴き、正しいスペルを感覚的に選択していくクイズゲーム。日常的な継続を促すため、`AppStorage` を用いた「連続学習日数（Streak）記録機能」も実装しています。

---

## 🛠️ 技術スタック

### 開発環境 / 言語
- **Environment**: Swift Playgrounds 5.x / Xcode 17
- **Language**: Swift 6.0 (Strict Concurrency Check 対応)

### フレームワーク / 技術要素
- **UI/UX**: `SwiftUI`, `UINotificationFeedbackGenerator` (Haptics)
- **AI / 音声解析**: `SoundAnalysis`, `Core ML` (自作音声分類モデルの動的コンパイル処理)
- **オーディオ制御**: `AVFoundation` (`AVAudioEngine`, `AVAudioSession`)
- **データ永続化**: `AppStorage`

---

## 💎 こだわり・工夫したポイント

- **ユーザーを挫折させない「AI判定の最適化」**
  自作AIモデルの特性上、マイク環境等によるシビアな判定になりがちだったため、検出時の自信度（Confidence）の閾値を動的に調整。一瞬でも正解の音素をかすめたら成功とするロジックを組み込み、学習者のモチベーションを削がない「優しいUX」と精度の安定を両立させました。
- **マルチセンサによる学習体験**
  視覚的なダークモードUI、聴覚的な音声フィードバックに加え、正解時には心地よい触覚フィードバック（Haptics）を返すことで、五感で発音の成功を感じられる「マルチセンサ・ループ」を意識した実装を行っています。
- **Swift 6 への並行処理対応**
  音声解析スレッドとUI描画スレッドの競合を避けるため、`@MainActor` や `nonisolated(unsafe)` などを適切に配置し、データレースを完全に排除したスレッド安全な設計を行っています。

---

## 🚀 今後の展望
- **アクセシビリティの徹底的な強化**
  年齢やデジタルリテラシーを問わず誰もが直感的に使えるよう、家族や友人にプロトタイプを触ってもらうユーザーテストを重ね、`Dynamic Type`（文字サイズ可変）の最適化や、さらに直感的なタップエリアの確保など、ユニバーサルデザインへのブラッシュアップを進めます。
- **学習進捗チャートの視覚化**
  `Swift Charts` を用い、苦手な音素の傾向をグラフで視覚的に振り返ることができるダッシュボード機能の追加。
